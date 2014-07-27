Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaG0Rk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:40:28 -0400
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:58902 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaG0Rk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:40:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:4250:4321:5007:7652:8531:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soap26_780ee88768b18
X-Filterd-Recvd-Size: 1107
Message-ID: <1406482822.5285.7.camel@joe-AO725>
Subject: Re: [PATCH] staging: ft1000: fix some checkpatch complaints
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nicolas Thery <nthery@gmail.com>, marek.belisko@gmail.com, me@aldo.io,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 27 Jul 2014 10:40:22 -0700
In-Reply-To: <20140727173538.GA27056@kroah.com>
References: <1406480913-31378-1-git-send-email-nthery@gmail.com>
	 <1406481833.5285.6.camel@joe-AO725> <20140727173538.GA27056@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 10:35 -0700, Greg KH wrote:
> How about removing the proc files entirely, as I doubt they are really
> needed :)

unnecessary proc entry removals are always good too.

