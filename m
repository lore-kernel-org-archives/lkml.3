Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaHDMaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:30:06 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37235 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHDMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:30:04 -0400
Date: Mon, 4 Aug 2014 14:29:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/apic changes for v3.17
Message-ID: <20140804122954.GA27756@gmail.com>
References: <20140804113402.GA25437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804113402.GA25437@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest x86-apic-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus
> 
>    # HEAD: 5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7 x86/apic/vsmp: Make is_vsmp_box() static
> 
> 
> The main changes in this cycle are:
> 
>     * Remove obsolete APIC driver abstractions. (David Rientjes)
> 
>     * Use the irqdomain facilities to dynamically allocate IRQs for 
>       IOAPICs. This is a prerequisite to enable IOAPIC hotplug 
>       support, and it also frees up wasted vectors. (Jiang Liu)
> 
>     * Misc fixlets.

Linus, please hold off on pulling this tree for the time being - I 
thought it's regression free, but Boris just told me that he is still 
seeing unsolved regressions with it.

Sorry about this, I will resend it once it's all known-good.

Thanks,

	Ingo
