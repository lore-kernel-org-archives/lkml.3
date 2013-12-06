Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3LFHS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:18:28 -0500
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:54121 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752016Ab3LFHS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:18:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3873:3874:4321:5007:7652:10004:10400:10471:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lamp96_2c7850034e263
X-Filterd-Recvd-Size: 1812
Message-ID: <1386314303.31845.20.camel@joe-AO722>
Subject: Re: [PATCH] staging: silicom: fix 'return is not a function,
 parentheses are not required' in bpctl_mod.c
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Will Tange <bh34rt@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Dec 2013 23:18:23 -0800
In-Reply-To: <20131206071112.GF5443@mwanda>
References: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
	 <20131205225051.GC28413@mwanda> <1386284955.10003.20.camel@joe-AO722>
	 <20131205232140.GE5443@mwanda> <1386286162.10003.24.camel@joe-AO722>
	 <20131206071112.GF5443@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 10:11 +0300, Dan Carpenter wrote:
> On Thu, Dec 05, 2013 at 03:29:22PM -0800, Joe Perches wrote:
> > On Fri, 2013-12-06 at 02:21 +0300, Dan Carpenter wrote:
> > > On Thu, Dec 05, 2013 at 03:09:15PM -0800, Joe Perches wrote:
> > > > On Fri, 2013-12-06 at 01:50 +0300, Dan Carpenter wrote:
> > > > > On Thu, Dec 05, 2013 at 10:23:53PM +0100, Will Tange wrote:
> > 
> > Ah.
> > 
> > Then maybe use a single ?: or a ! instead
> > 
> > 	return ret ? 0 : 1;
> > or
> > 	return !ret;
> > 
> 
> You still have to handle the negative.
> 
> 	if (ret < 0)
> 		return ret;
> 
> 	return !ret;

Of course.  Apologies for not being clear.  I meant
using that ?: or ! after the first if (ret < 0) as
you wrote.

