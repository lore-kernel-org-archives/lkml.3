Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbaGPNVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:21:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46623 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaGPNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:21:27 -0400
Date: Wed, 16 Jul 2014 15:21:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140716132114.GA17163@gmail.com>
References: <20140715132946.771def89@canb.auug.org.au>
 <53C4BF8E.4010509@roeck-us.net>
 <20140715155547.25959587@canb.auug.org.au>
 <20140715150801.7f8099b1@recife.lan>
 <20140715190807.GA26057@roeck-us.net>
 <20140716130434.6b09b2e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716130434.6b09b2e1@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Guenter,
> 
> On Tue, 15 Jul 2014 12:08:07 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > > > > Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that was accepted
> > > > > a week or so ago.
> > > > 
> > > > That is in the tip tree and includes the fixups to powerpc and arm.  I
> > > > don't merge the tip tree till well after the v4l-dvb tree.  The merge
> > > > in the v4l-dvb tree included only the change to include/linus/sched.h
> > > > and neither parent fo that merge was based on the tip tree ...
> > > > 
> > > Stephen, 
> > > 
> > > Do you know if/when this patch will be merged upstream? It doesn't
> > > seem to be at 2.6.16-rc5. Otherwise, I'll likely cherry-pick it on
> > 	s/2.16/3.16/
> > > my trees, as the lack of this fixup is making hard for me to check
> > > if a media tree patch isn't introducing new warnings.
> > 
> > Only queued for 3.17 as far as I can see, and not scheduled for 3.16.
> 
> Its in the sched/urgent branch of the tip tree, so hopefully it will go
> to Linus shortly.
> 
> [ccing various tip tree maintainers ...]
> 
> Hi guys, this commit (b6220ad66 (sched: Fix compiler warnings)) fixes
> lots of W=1 build warnings ... just wondering when it will progress?

FYI, I sent the fix to Linus earlier today.

Thanks,

	Ingo
