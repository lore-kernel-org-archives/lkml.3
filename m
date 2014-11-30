Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaK3Izh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:55:37 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:43741 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751846AbaK3Izf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:55:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:560:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4321:5007:6261:10004:10400:10848:10967:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21060:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nest64_6ad54d207d849
X-Filterd-Recvd-Size: 1720
Message-ID: <1417337732.818.8.camel@perches.com>
Subject: Re: [PATCH] sound: use enum names instead of magic numbers
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sun, 30 Nov 2014 00:55:32 -0800
In-Reply-To: <s5h1tolaxmc.wl-tiwai@suse.de>
References: <1417201196-12392-1-git-send-email-KyleChamberlin@project20million.org>
	 <s5h7fydbv6w.wl-tiwai@suse.de> <1417294692.818.3.camel@perches.com>
	 <s5h1tolaxmc.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-30 at 09:41 +0100, Takashi Iwai wrote:
> At Sat, 29 Nov 2014 12:58:12 -0800,
> Joe Perches wrote:
> > 
> > There's an enum defined for these magic numbers,
> > might as well use it.
> > 
> > Miscellanea:
> > o Use ##__VA_ARGS__
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Any specific reason to hang to an irrelevant thread?

Not in particular, I just noticed it there.

> Also...

> > diff --git a/include/sound/core.h b/include/sound/core.h
[]
> > +#define __snd_printk(snd_level, file, line, format, ...) \
> > +	printk(format, ##__VA_ARGS__)
> 
> It's better to keep the argument name "level".  Using both the same
> name for a variable and its enum type is rather confusing, and just
> gives unnecessary LOCs.

Write it as you chose.  It is pretty trivial.

