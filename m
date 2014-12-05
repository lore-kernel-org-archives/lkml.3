Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLEP0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:26:53 -0500
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:56505 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592AbaLEP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:26:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:965:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3874:4321:4390:5007:6261:7808:10004:10226:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: room48_1eace4da18a26
X-Filterd-Recvd-Size: 1189
Message-ID: <1417793209.2721.53.camel@perches.com>
Subject: Re: printf vs. printk (was Re: Side-effect free printk?)
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Julia Lawall <julia.lawall@lip6.fr>, cocci <cocci@systeme.lip6.fr>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Dec 2014 07:26:49 -0800
In-Reply-To: <1417793094.2721.51.camel@perches.com>
References: <1417629003.2902.14.camel@perches.com>
	 <20141205103248.GA6945@amd> <1417793094.2721.51.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 07:24 -0800, Joe Perches wrote:
> My preference would be to eventually eliminate printk
> altogether but I don't see a real problem adding 
> 	#define printf printk
> to include/linux/printk.h
> 
> but

(bah, bad touchpad)

but I'm not going to write or ack that patch.


