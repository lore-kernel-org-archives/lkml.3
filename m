Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3LFSW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:22:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56725 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LFSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:22:56 -0500
Date: Fri, 6 Dec 2013 12:22:53 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch: hexagon: include: asm: add prefix "hvm[ci]_"
 for all enum members in "hexagon_vm.h"
Message-ID: <20131206182253.GD11490@codeaurora.org>
References: <528AEFB7.4060301@gmail.com>
 <20131125011938.GB18921@codeaurora.org>
 <5292B845.3010404@gmail.com>
 <5292B8A0.7020409@gmail.com>
 <5292B8D1.5050407@gmail.com>
 <52970421.3030104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52970421.3030104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:51:45PM +0800, Chen Gang wrote:
> Append "hvmc_" or "hvmi_" to all related enum members (which are too
> common to make conflict with another sub-systems). The related error
> with allmodconfig:
> 
>     CC [M]  drivers/md/raid1.o
>   drivers/md/raid1.c:1440:13: error: 'status' redeclared as different kind of symbol
>   arch/hexagon/include/asm/hexagon_vm.h:76:2: note: previous definition of 'status' was here
> 
> Also use 'affinity' instead of 'locdis' for __vmintop_affinity().
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/include/asm/hexagon_vm.h |   72 ++++++++++++++++----------------
>  1 files changed, 36 insertions(+), 36 deletions(-)
> 

Thanks for catching the affinity typo too.


Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
