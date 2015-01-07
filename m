Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbbAGAIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 19:08:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbbAGAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 19:08:28 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1420545252-35340-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Tue, 06 Jan 2015 19:07:51 -0500
In-Reply-To: <1420545252-35340-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 6 Jan 2015 17:24:12 +0530")
Message-ID: <yq1y4pf78rs.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> For any SCSI command, if the driver receives IOC status =
Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
Sreekanth> command will be completed with DID_RESET host status.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
