Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3JNPll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:41:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41123 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3JNPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:41:40 -0400
Date: Mon, 14 Oct 2013 16:40:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Optimize jump label implementation on ARM64
Message-ID: <20131014154044.GR25034@n2100.arm.linux.org.uk>
References: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381675827-1610-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 10:50:20PM +0800, Jiang Liu wrote:
> To enable this feature, your toolchain must support "asm goto" extension
> and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
> "%c", so you need a GCC patch similiar to this:

Oh god, not that again.  I've no idea why ARM stuff has such a problem with
supporting this very useful "%c" GCC constraint.  Aarch32 didn't for ages
consequently we now have horrid hacks around it in the kernel source
because our compilers suck.  Seems Aarch64 is doomed to repeat the same
stupid mistakes. :(
