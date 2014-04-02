Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbaDBXze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:55:34 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:60548 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932312AbaDBXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:55:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3874:4250:4321:5007:6119:7652:8957:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range19_878dfa7921b5a
X-Filterd-Recvd-Size: 1768
Message-ID: <1396482929.32040.23.camel@joe-AO722>
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and
 strings style rule
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sherif <silentquote@gmail.com>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Apr 2014 16:55:29 -0700
In-Reply-To: <20140402234810.GA545@kroah.com>
References: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com>
	 <1396480892.32040.17.camel@joe-AO722> <533C9F2A.9000102@gmail.com>
	 <1396482038.32040.19.camel@joe-AO722> <20140402234810.GA545@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 16:48 -0700, Greg KH wrote:
> On Wed, Apr 02, 2014 at 04:40:38PM -0700, Joe Perches wrote:
> > On Thu, 2014-04-03 at 01:37 +0200, Sherif wrote:
> > > BTW regarding "Alignment should match open parenthesis" rule, It's 
> > > missing from Documentation/CodingStyle
> > 
> > It's "maintainer's preference" in at least
> > net/, drivers/net and drivers/staging.
> > 
> > Maybe it's true for drivers/usb too.
> > 
> > Greg?
> 
> Yes, I "prefer" that as well, but if that's the only thing wrong with
> the code, I really don't care.

I generally don't care much either, but this patch was
also changing lines from the preferred indentation style
to something else.

cheers, Joe

