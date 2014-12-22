Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaLVU4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:56:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbaLVU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:56:52 -0500
Date: Mon, 22 Dec 2014 21:56:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>, mmarek@suse.cz
Subject: Re: Linux 3.19-rc1 - merge window closed
In-Reply-To: <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com> <1419145899.8696.5.camel@haakon3.risingtidesystems.com> <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014, Andrew Morton wrote:

> On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Just hit the following build failure with CONFIG_AUDIT=y:
> > 
> > arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> > arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> > arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> > make[2]: *** [arch/x86/ia32/audit.o] Error 1
> > make[1]: *** [arch/x86/ia32] Error 2
> > make: *** [arch/x86] Error 2
> > make: *** Waiting for unfinished jobs....
> 
> Your .config works for me.  Does a `make mrproper' fix it?
> 
> I've seen a few reports like this in recent months.  Something's
> up with the build dependency system.

Let's add Michal Marek to CC then.

-- 
Jiri Kosina
SUSE Labs

