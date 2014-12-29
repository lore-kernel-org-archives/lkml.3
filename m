Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaL2DBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 22:01:12 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:36045 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751747AbaL2DBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 22:01:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3165:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7514:7652:7903:8985:9025:9038:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: self49_9cb03bacfe4d
X-Filterd-Recvd-Size: 2018
Message-ID: <1419822060.18886.1.camel@perches.com>
Subject: Re: [PATCH] fs: overlayfs: Fix coding style issues, missing a blank
 line after declarations
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 28 Dec 2014 19:01:00 -0800
In-Reply-To: <20141229024951.GA9934@ZenIV.linux.org.uk>
References: <1419746213-5405-1-git-send-email-kuleshovmail@gmail.com>
	 <20141229023939.GL22149@ZenIV.linux.org.uk>
	 <20141229024951.GA9934@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-29 at 02:49 +0000, Al Viro wrote:
> On Mon, Dec 29, 2014 at 02:39:39AM +0000, Al Viro wrote:
> > On Sun, Dec 28, 2014 at 11:56:53AM +0600, Alexander Kuleshov wrote:
> > > Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> > > ---
> > 
> > For the record: anything of that sort against fs/*.c will be flushed down
> > the toilet where such valuable contributions belong.  Don't even bother.
> 
> Joe, could you please explain what has driven you to include that into
> scripts/checkpatch.pl and open the countless sphincters?  Aren't we
> getting enough pointless patches as it is?

I don't care for that style actually.
It was Andrew Morton that wanted it used globally.

I wanted it to be a --strict test and only for
net/ and drivers/net/ where David Miller prefers
that style.

https://lkml.org/lkml/2014/3/6/550

> Al, stongly tempted to try and sneak a patch to checkpatch.pl declaring the
> lack of /* See Figure 1 */ within the first 10 lines of a function an offense
> against the Gods Of Style.  Then sit back and watch the resulting spew...

Cool.  Awaiting your patch...


