Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaLDC7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:59:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51605 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaLDC7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:59:15 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/22] [SCSI] mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header files
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-6-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 03 Dec 2014 21:58:40 -0500
In-Reply-To: <1416467155-16869-6-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:38 +0530")
Message-ID: <yq1iohsi0in.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Change List in this MPI2 specification, 1. Added SSUTimeout
Sreekanth> field to MPI2_CONFIG_PAGE_BIOS_1, and more defines for the
Sreekanth> BiosOptions field.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
