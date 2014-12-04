Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaLDDG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:06:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18416 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaLDDGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:06:24 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 03 Dec 2014 22:05:49 -0500
In-Reply-To: <1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:39 +0530")
Message-ID: <yq1egsgi06q.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. Removed the upper boundary restriction for the module
Sreekanth> parameter max_sgl_entries. Earlier, the max_sgl_entries was
Sreekanth> capped at the SCSI_MAX_SG_SEGMENTS kernel definition. With
Sreekanth> this change, the user would be able to set the
Sreekanth> max_sgl_entries to any value.

Shouldn't you be capping at SCSI_MAX_SG_CHAIN_SEGMENTS (or the actual hw
limit)?

-- 
Martin K. Petersen	Oracle Linux Engineering
