Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbbAIUzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:55:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbAIUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:55:51 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1420635235-2222-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Fri, 09 Jan 2015 15:55:05 -0500
In-Reply-To: <1420635235-2222-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Wed, 7 Jan 2015 18:23:55 +0530")
Message-ID: <yq1y4pbznbq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. Extended the upper boundary restriction for the module
Sreekanth> parameter max_sgl_entries.  Earlier, the max_sgl_entries was
Sreekanth> capped at the SCSI_MAX_SG_SEGMENTS kernel definition.  With
Sreekanth> this change, the user would be able to set the
Sreekanth> max_sgl_entries to any value which is greater than
Sreekanth> SCSI_MAX_SG_SEGMENTS and less than the minimum of
Sreekanth> SCSI_MAX_SG_CHAIN_SEGMENTS & hardware limit(Calculated using
Sreekanth> IOCFacts's MaxChainDepth).

Sreekanth> 2. Added a print for the message log whenever the user sets
Sreekanth> the max_sgl_entries to a value greater than
Sreekanth> SCSI_MAX_SG_SEGMENTS to warn about the kernel definition
Sreekanth> overriding.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
