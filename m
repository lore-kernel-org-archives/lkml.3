Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaDAB5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:57:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaDAB5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:57:04 -0400
Message-ID: <533A1CB8.1060401@zytor.com>
Date: Mon, 31 Mar 2014 18:56:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>	<20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>	<20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>	<alpine.DEB.2.02.1403311140180.14882@ionos.tec.linutronix.de>	<20140331215743.a357aa685a63c06ea303dbba@canb.auug.org.au> <20140401112637.454be94f789d5fd9db729dcd@canb.auug.org.au>
In-Reply-To: <20140401112637.454be94f789d5fd9db729dcd@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 05:26 PM, Stephen Rothwell wrote:
> 
> And today from Linus' tree I get these:
> 
> x86_64_allmodconfig:
> 
> arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes] static asmlinkage void (*sha1_transform_asm)(u32 *,
> const char *, unsigned int); ^ 
> arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes] static asmlinkage void (*sha256_transform_asm)(const
> char *, u32 *, u64); ^ arch/x86/crypto/sha512_ssse3_glue.c:55:1:
> warning: 'externally_visible' attribute have effect only on public
> objects [-Wattributes] static asmlinkage void
> (*sha512_transform_asm)(const char *, u64 *, u64); ^
> 
> arm_multi_v7_defconfig:
> 
> drivers/irqchip/irq-sun4i.c:39:70: warning: 'externally_visible'
> attribute have effect only on public objects [-Wattributes] 
> drivers/irqchip/irq-sun4i.c:140:1: warning: 'externally_visible'
> attribute have effect only on public objects [-Wattributes] 
> drivers/irqchip/irq-armada-370-xp.c:357:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes] drivers/irqchip/irq-gic.c:283:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes] drivers/irqchip/irq-sirfsoc.c:51:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes] drivers/irqchip/irq-vt8500.c:183:1: warning:
> 'externally_visible' attribute have effect only on public objects
> [-Wattributes]
> 

Please see the tree "[GIT PULL] x86 LTO changes for v3.15".

	-hpa

