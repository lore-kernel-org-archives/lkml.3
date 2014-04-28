Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaD1Jku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:40:50 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38110 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaD1Jko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:40:44 -0400
Date: Mon, 28 Apr 2014 10:40:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mfd: sec-core: Update sec_pmic documentation
Message-ID: <20140428094037.GQ6264@lee--X1>
References: <1398326738-17248-1-git-send-email-k.kozlowski@samsung.com>
 <20140428093832.GP6264@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140428093832.GP6264@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Update the documentation for sec_pmic state container structure to
> > reflect current code.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > 
> > ---
> > Changes since v2:
> >  - Rebased on lee/mfd.
> 
> You did? Which tree/branch? I still get:
> 
> Applying: mfd: sec-core: Update sec_pmic documentation
> Using index info to reconstruct a base tree...
> M	include/linux/mfd/samsung/core.h
> Falling back to patching base and 3-way merge...
> Auto-merging include/linux/mfd/samsung/core.h
> CONFLICT (content): Merge conflict in include/linux/mfd/samsung/core.h
> Recorded preimage for 'include/linux/mfd/samsung/core.h'
> Failed to merge in the changes.
> Patch failed at 0002 mfd: sec-core: Update sec_pmic documentation
> The copy of the patch that failed is found in:
>    /home/lee/projects/linux/.git/rebase-apply/patch
> When you have resolved this problem, run "git am --resolved".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am -abort".

Okay, I fixed it - now applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
