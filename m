Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaIVNnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:43:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:43:41 -0400
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH][SCSI] mpt2sas: fix undefined reference to `__udivdi3' compilation errors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Mon, 22 Sep 2014 09:42:49 -0400
In-Reply-To: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 19 Sep 2014 12:17:27 +0530")
Message-ID: <yq17g0vwz3a.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> This patch will fix the below compilation errors on i386 ARCH
Sreekanth> drivers/built-in.o: In function `_scsih_qcmd':
Sreekanth> mpt2sas_scsih.c:(.text+0x1e7b56): undefined reference to
Sreekanth> `__udivdi3' mpt2sas_scsih.c:(.text+0x1e7b8a): undefined
Sreekanth> reference to `__umoddi3'

Sreekanth> Used sector_div() API to fix above compilation errors.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
