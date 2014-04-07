Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaDGWDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:03:31 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:55787 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755051AbaDGWDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:03:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:966:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hour01_1e46a79329227
X-Filterd-Recvd-Size: 1808
Message-ID: <1396908206.2874.66.camel@joe-AO722>
Subject: Re: [PATCH v2 4/5] Staging: rts5139: pr_warn(...) in place of
 printk(KERN_WARNING ...)
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Fabio Falzoi <fabio.falzoi84@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Apr 2014 15:03:26 -0700
In-Reply-To: <20140407205659.GA7966@kroah.com>
References: <20140407003341.GA13365@kroah.com>
	 <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
	 <1396902468-27906-5-git-send-email-fabio.falzoi84@gmail.com>
	 <1396902887.2874.62.camel@joe-AO722> <20140407205659.GA7966@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 13:56 -0700, Greg KH wrote:
> On Mon, Apr 07, 2014 at 01:34:47PM -0700, Joe Perches wrote:
> > On Mon, 2014-04-07 at 22:27 +0200, Fabio Falzoi wrote:
> > > All printk(KERN_WARNING ...) replaced with pr_warn(...).
> > 
> > Please remove the RTS51X_TIP prefix and and and use
> > 
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> > before any #include so that pr_<level> uses
> > are prefixed in a standard way.
> 
> 
> Feel free to do this as a follow-on patch, I'll take this one as-is, as
> it is better than what we have currently...

<shrug>

Seeing as how you're not applying staging patches until
after -rc1 is out, I don't see the harm in asking the
submitter to fix whatever issues exist in a patch set
before that.

