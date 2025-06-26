// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FreelanceMarketplace {
    uint public jobCounter;

    enum JobStatus { Open, Taken, Completed }

    struct Job {
        uint id;
        address payable client;
        address payable freelancer;
        string description;
        uint256 payment;
        JobStatus status;
    }

    mapping(uint => Job) public jobs;

    event JobPosted(uint indexed id, address indexed client, uint256 payment);
    event JobTaken(uint indexed id, address indexed freelancer);
    event JobCompleted(uint indexed id);

    function postJob(string calldata _description) external payable {
        require(msg.value > 0, "Payment must be greater than 0");

        jobCounter++;
        jobs[jobCounter] = Job({
            id: jobCounter,
            client: payable(msg.sender),
            freelancer: payable(address(0)),
            description: _description,
            payment: msg.value,
            status: JobStatus.Open
        });

        emit JobPosted(jobCounter, msg.sender, msg.value);
    }

    function takeJob(uint _jobId) external {
        Job storage job = jobs[_jobId];
        require(job.status == JobStatus.Open, "Job is not available");
        job.freelancer = payable(msg.sender);
        job.status = JobStatus.Taken;

        emit JobTaken(_jobId, msg.sender);
    }

    function markCompleted(uint _jobId) external {
        Job storage job = jobs[_jobId];
        require(msg.sender == job.client, "Only client can confirm completion");
        require(job.status == JobStatus.Taken, "Job is not in progress");

        job.status = JobStatus.Completed;
        job.freelancer.transfer(job.payment);

        emit JobCompleted(_jobId);
    }

    function getJob(uint _jobId) public view returns (Job memory) {
        return jobs[_jobId];
    }
}
