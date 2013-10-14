Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3JNPUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:20:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47775 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab3JNPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:20:13 -0400
Date: Mon, 14 Oct 2013 16:19:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] Optimize jump label implementation on ARM64
Message-ID: <20131014151938.GJ10491@mudshark.cambridge.arm.com>
References: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 03:50:20PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> This patchset tries to optimize arch specfic jump label implementation
> for ARM64 by dynamic kernel text patching.
> 
> To enable this feature, your toolchain must support "asm goto" extension
> and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
> "%c", so you need a GCC patch similiar to this:
> http://gcc.gnu.org/viewcvs/gcc/trunk/gcc/config/arm/arm.c?view=patch&r1=175293&r2=175565&pathrev=175565
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637

Right, but this is just for the ARM (AArch32) backend afaict. Are there any
plans for upstream GCC to support this constraint for AArch64?

Will
