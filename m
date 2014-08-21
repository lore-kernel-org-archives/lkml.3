Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaHUUgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:36:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23937 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaHUUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:36:39 -0400
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Thu, 21 Aug 2014 16:35:59 -0400
In-Reply-To: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 12 Aug 2014 14:54:42 +0530")
Message-ID: <yq1wqa1r368.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Sending the this patch once agin using git send-email.  Up to
Sreekanth> now, Driver allocates a single contiguous block of memory
Sreekanth> pool for all reply queues and passes down a single address in
Sreekanth> the ReplyDescriptorPostQueueAddress field of the IOC Init
Sreekanth> Request Message to the firmware.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
