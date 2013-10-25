Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3JYPK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:10:57 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:57589 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754628Ab3JYPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:10:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3673:3865:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pest95_7bc22322e9745
X-Filterd-Recvd-Size: 1315
Message-ID: <1382713844.2501.14.camel@joe-AO722>
Subject: Re: [PATCH -resend 1/1] dumpstack: fix printk_address for direct
 addresses
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: x86@kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 25 Oct 2013 08:10:44 -0700
In-Reply-To: <1382706418-8435-1-git-send-email-jslaby@suse.cz>
References: <1382706418-8435-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 15:06 +0200, Jiri Slaby wrote:

> I sent this patch 2 weeks ago. Only Joe commented that the prints
> should be done inline instead. But I don't agree as prining the output
> from one point is better IMHO.

Doing it inline avoids any possible interleaving
by other thread output in dmesg.


