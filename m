Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaLDCuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:50:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49773 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaLDCuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:50:19 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/22] [SCSI] mpt2sas: MPI2 Rev AA (2.00.19) specifications
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-2-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 03 Dec 2014 21:49:41 -0500
In-Reply-To: <1416467155-16869-2-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:34 +0530")
Message-ID: <yq1zjb4i0xm.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Below is the changeset from the MPI specification and 2.00.34
Sreekanth> header files 1) Defined additional bits in the BiosOptions
Sreekanth> field of BIOS Page 1 to allow for finer control of X86 BIOS
Sreekanth> and UEFI BSD.  2) For the Clean Tool, reserved bit 26 of the
Sreekanth> Flags field for product specific use.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
