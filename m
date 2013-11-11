Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3KKJU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:20:28 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:50484
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab3KKJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:20:22 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2013 04:20:22 EST
From: Tim Sander <tim@krieglstein.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.0-rt1
Date: Mon, 11 Nov 2013 10:10:16 +0100
Message-ID: <4531942.TIokzIBNEm@dabox>
User-Agent: KMail/4.11.2 (Linux/3.9.3; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131110193059.GA7537@linutronix.de>
References: <20131110193059.GA7537@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian
> I'm pleased to announce the v3.12.0-rt1 patch set.
> 
> Changes since v3.10.18-rt14
> - updated to v3.12
> - dropped SLAB support. It was broken in v3.10 and therefore not available
>   for RT. Nobody complained except that it did not compile on !RT. Since
>   SLUB performs a little better compared to SLAB and is the default
>   allocator I think it is okay to drop SLAB support.
> - the PREEMPT_RT Kconfig patches are now very early in the queue.
> 
> This is the first release of the v3.12 kernel. It run a couple of days on
> powerpc and x86 without an accident :)
Thanks for that release! Is ARM omitted because you didn't test it or because 
of issues of some kind?

Thanks
Tim
