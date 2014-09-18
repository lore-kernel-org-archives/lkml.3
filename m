Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaIRWcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:32:53 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33822 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754380AbaIRWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:32:52 -0400
Date: Thu, 18 Sep 2014 23:32:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Krait VFP fixes
Message-ID: <20140918223241.GE5182@n2100.arm.linux.org.uk>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to be copied on these patches, as the VFP code is
entirely my creation...  I'll review these patches shortly.

On Thu, Sep 18, 2014 at 02:43:09PM -0700, Stephen Boyd wrote:
> These changes allow us to support VFP correctly on Krait processors.
> They also fix short vector emulation for Cortex-A15 and Krait.
> 
> Stepan Moskovchenko (1):
>   arm: vfp: Bounce undefined instructions in vectored mode
> 
> Stephen Boyd (2):
>   ARM: vfp: Workaround bad MVFR1 register on some Kraits
>   ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp implementations
> 
>  arch/arm/include/asm/cputype.h | 1 +
>  arch/arm/include/asm/vfp.h     | 2 +-
>  arch/arm/mm/proc-v7.S          | 5 +++--
>  arch/arm/vfp/vfphw.S           | 6 ++++++
>  arch/arm/vfp/vfpmodule.c       | 7 +++++++
>  5 files changed, 18 insertions(+), 3 deletions(-)
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
