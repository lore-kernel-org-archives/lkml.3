Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaCRTUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:20:41 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:58719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754315AbaCRTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:20:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: month28_3fa1393a23144
X-Filterd-Recvd-Size: 1080
Message-ID: <1395170436.2812.69.camel@joe-AO722>
Subject: Re: [patch 08/12 V2] can: c_can: Makethe code readable
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Mar 2014 12:20:36 -0700
In-Reply-To: <alpine.DEB.2.02.1403181924440.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de>
	 <20140318171127.430027680@linutronix.de>
	 <1395164220.2812.59.camel@joe-AO722>
	 <alpine.DEB.2.02.1403181924440.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 19:27 +0100, Thomas Gleixner wrote:
>  V2: Remove the pointless multiwhile.

fyi, I didn't find another multiwhile in the kernel tree.


