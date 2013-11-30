Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab3K3S1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 13:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab3K3S1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 13:27:44 -0500
Date: Sat, 30 Nov 2013 18:31:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131130173118.GA26278@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <20131130165122.GA24507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130165122.GA24507@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30, Oleg Nesterov wrote:
>
> First of all, this smp_wmb() is not clear.

Yes, but...

> However, do_int3() does preempt_conditional_sti() and this looks
> as if it can be called with irqs enabled?

Ah, please ignore, I misread preempt_conditional_sti(). It enables
irqs if they were enabled before the exception, unless I misread it
again.

Oleg.

