Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaDQBXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:23:17 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:33849 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998AbaDQBXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:23:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2196:2198:2199:2200:2393:2553:2559:2562:2731:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3874:4321:4385:5007:7652:10004:10394:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plant16_7272dbf1fa318
X-Filterd-Recvd-Size: 1673
Message-ID: <1397697785.4603.6.camel@joe-AO725>
Subject: Re: [DRIVER CORE] drivers/base/dd.c incorrect pr_debug() parameters
From: Joe Perches <joe@perches.com>
To: frowand.list@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 16 Apr 2014 18:23:05 -0700
In-Reply-To: <534F2A88.8050408@gmail.com>
References: <534F1C6E.7010606@gmail.com> <1397695738.4603.2.camel@joe-AO725>
	 <534F2A88.8050408@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 18:12 -0700, Frank Rowand wrote:
> On 4/16/2014 5:48 PM, Joe Perches wrote:
> > On Wed, 2014-04-16 at 17:12 -0700, Frank Rowand wrote:
> >> pr_debug() parameters are reverse order of format string
> > 
> > Another way to do this might be to change all the
> > printks/pr_debugs to dev_<level>
> 
> Yes, but if that is done, one may as well do all of drivers/base/*.c
> and drivers/base/*/*.c

Actually, I don't think so, no.

These are the ones that have a struct device attached
to them.  Many of the others are device free and are
prefixed differently, like power and devtmpfs and bus.

> I was only trying to fix incorrectly reported information from one
> pr_debug().  If someone else want to do a big conversion, they are
> free to.  :-)

Always true...

cheers, Joe

