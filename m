Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaAFSso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:48:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35199 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbaAFSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:48:42 -0500
Date: Mon, 6 Jan 2014 18:48:09 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20140106184808.GJ1096@mudshark.cambridge.arm.com>
References: <1387725944-810-1-git-send-email-liuj97@gmail.com>
 <1387725944-810-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387725944-810-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 03:25:38PM +0000, Jiang Liu wrote:
> Introduce three interfaces to patch kernel and module code:
> aarch64_insn_patch_text_nosync():
> 	patch code without synchronization, it's caller's responsibility
> 	to synchronize all CPUs if needed.
> aarch64_insn_patch_text_sync():
> 	patch code and always synchronize with stop_machine()
> aarch64_insn_patch_text():
> 	patch code and synchronize with stop_machine() if needed
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h |  10 +++-
>  arch/arm64/kernel/insn.c      | 119 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 128 insertions(+), 1 deletion(-)

  Reviewed-by: Will Deacon <will.deacon@arm.com>

Thanks!

Will
