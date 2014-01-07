Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaAGPrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:47:43 -0500
Received: from [217.140.96.50] ([217.140.96.50]:57173 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaAGPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:47:36 -0500
Date: Tue, 7 Jan 2014 15:46:23 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20140107154622.GA4399@mudshark.cambridge.arm.com>
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
 <1389104234-15239-7-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389104234-15239-7-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:17:13PM +0000, Jiang Liu wrote:
> Optimize jump label implementation for ARM64 by dynamically patching
> kernel text.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/Kconfig                  |  1 +
>  arch/arm64/include/asm/jump_label.h | 52 +++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/Makefile          |  1 +
>  arch/arm64/kernel/jump_label.c      | 58 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 112 insertions(+)
>  create mode 100644 arch/arm64/include/asm/jump_label.h
>  create mode 100644 arch/arm64/kernel/jump_label.c

  Reviewed-by: Will Deacon <will.deacon@arm.com>

Thanks for sticking with this! I think this series is good for merging now.

Will
