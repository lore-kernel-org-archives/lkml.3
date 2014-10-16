Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaJPNOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:14:06 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:61769 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJPNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 16 Oct 2014 09:14:03 -0400
Message-ID: <CAF6AEGvS8+sPJ+tNoLBTeXnqwf=_oCfry2DzacMmYveh6vLS0w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] VFP fixes
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 9:48 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> These changes allow us to detect VFP correctly on Krait processors.
> They also fix short vector emulation for Cortex-A15 and Krait.
>
> Changes since v1:
>  * Move to use CPUID and MVFR0 in patch 2
>  * Patches 1 and 3 unchanged
>
> Stepan Moskovchenko (1):
>   arm: vfp: Bounce undefined instructions in vectored mode
>
> Stephen Boyd (2):
>   ARM: vfp: Workaround bad MVFR1 register on some Kraits
>   ARM: vfp: Fix VFPv3 hwcap detection on CPUID based cpus
>

for the series,

Tested-by: Rob Clark <robdclark@gmail.com>

>  arch/arm/include/asm/vfp.h |  5 +++
>  arch/arm/mm/proc-v7.S      |  5 ++-
>  arch/arm/vfp/vfphw.S       |  6 +++
>  arch/arm/vfp/vfpmodule.c   | 93 ++++++++++++++++++++++++++--------------------
>  4 files changed, 66 insertions(+), 43 deletions(-)
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
