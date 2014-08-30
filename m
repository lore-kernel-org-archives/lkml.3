Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaH3OJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 10:09:30 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:60769 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655AbaH3OJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 10:09:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3873:3874:4043:4321:5007:7652:10004:10226:10400:10848:11658:11914:12517:12519:12740:13069:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dirt91_6fadb3ae36753
X-Filterd-Recvd-Size: 1335
Message-ID: <1409407766.2664.0.camel@joe-AO725>
Subject: Re: [PATCH] mtd: denali: fix include guard and license block of
 denali.h
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Date: Sat, 30 Aug 2014 07:09:26 -0700
In-Reply-To: <20140829183050.GA1532@thin>
References: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
	 <20140829183050.GA1532@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 11:30 -0700, Josh Triplett wrote:
> (Side note: could we get checkpatch to complain about comment headers
> containing the name of the file they appear in?  They're always either
> redundant or wrong.)

Sure, if you can write a regex to determine an
incorrect filename.

Good luck with that.


