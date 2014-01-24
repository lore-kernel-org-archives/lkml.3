Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaAXACN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 19:02:13 -0500
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:38023 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaAXACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 19:02:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:5007:6117:6119:7514:7652:7809:7903:9010:10004:10400:10450:10455:10848:11232:11658:11914:12043:12296:12517:12519:12555:12740:13184:13229:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: month49_6a2ba77a20f2d
X-Filterd-Recvd-Size: 3294
Message-ID: <1390521727.32356.16.camel@joe-AO722>
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 23 Jan 2014 16:02:07 -0800
In-Reply-To: <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
	 <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
	 <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org>
	 <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 14:45 -0800, David Rientjes wrote:
> On Thu, 23 Jan 2014, Andrew Morton wrote:
> 
> > > $ ./scripts/get_maintainer.pl -f drivers/firmware/google/Kconfig
> > > linux-kernel@vger.kernel.org (open list)
> > > 
> > > I wonder why he's not listed as a recipient for patches from 
> > > get_maintainer.pl since it's clearly obvious he wrote the entire file.
> > 
> > I do wish get_maintainer was better about this.  You can apparently
> > make it dtrt with funky arguments, but --git-since and --git aren't
> > working for me.

Or use --interactive to figure out what's what when it
doesn't give you an answer you like.

> > 
> > get_maintainer's default output should answer the question "who do I
> > email about this file", and that ain't working :(

Complaints cheerfully ignored.
Suggestions gratefully accepted.

Files that haven't had changes in a long time
generally aren't maintained.

Old addresses frequently become stale and bounce.

It'd be better if there was a MAINTAINERS entry
for drivers/firmware/google.

Far be it for me to volunteer someone to be a
maintainer though.

Something like:
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c5d554..f4271d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3802,6 +3802,11 @@ F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
 F:	include/uapi/linux/gigaset_dev.h
 
+GOOGLE MEMORY CONSOLE
+M:     Mike Waychison <mikew@google.com>
+S:     Supported
+F:     drivers/firmware/google/
+
 GPIO SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
 M:	Alexandre Courbot <gnurou@gmail.com>

> > 
> 
> I also think it would be great if get_maintainer's output was friendlier 
> so that I can just copy a comma-separated line of "name <email>, name2 
> <email2>" into my email client.

That's what it was, then people complained about not knowing
what the people did to the particular files being modified
and the default became --rolestats.

You can get that comma separated list by adding
--norolestats --nomultiline


