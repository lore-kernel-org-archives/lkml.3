Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaLJUlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:41:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16689 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaLJUlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:41:15 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1a934i055.fsf@sermon.lab.mkp.net>
	<CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
Date: Wed, 10 Dec 2014 15:40:38 -0500
In-Reply-To: <CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 17:38:32 +0530")
Message-ID: <yq161djdyrd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> For any SCSI command, if the driver receives IOC status =
Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
Sreekanth> command will be completed with DID_RESET host status.
>> 
>> What does that log info value mean?

Sreekanth> The meaning of this log info value is "Virtual IO has failed
Sreekanth> and has to be retried".

OK, I'd prefer to see that documented in the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
