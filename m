Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaLDC6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:58:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51803 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaLDC6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:58:18 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] [PATCH] mpt2sas, mpt3sas: Fail the host reset initiated due to discovery related I/O timeouts at driver load time
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-4-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 03 Dec 2014 21:57:45 -0500
In-Reply-To: <1416467155-16869-4-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:36 +0530")
Message-ID: <yq1r3wgi0k6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> When a flaky disk is there in a topology then during driver
Sreekanth> load, discovery related I/O times out; which results in SCSI
Sreekanth> error recovery initiating host reset and then the controller
Sreekanth> won't see any disk.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
