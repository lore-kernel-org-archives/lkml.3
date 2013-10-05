Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3JEPlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:41:15 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:50896 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751911Ab3JEPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:41:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3871:4321:5007:7652:8603:10004:10400:10471:10848:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cent98_61da9fae4901a
X-Filterd-Recvd-Size: 1081
Message-ID: <1380987671.2081.122.camel@joe-AO722>
Subject: Re: [PATCH] kernel/irq/proc.c: set MAX_NAMELEN 11 instead of 10
 which express the maximize size of "%d" or "%u".
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 05 Oct 2013 08:41:11 -0700
In-Reply-To: <52502E14.5040507@asianux.com>
References: <52502E14.5040507@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-05 at 23:19 +0800, Chen Gang wrote:
> Theoretically, the maximize size of "%d" or "%u" is 11 (10 + '\0'), so
> need set MAX_NAMELEN 11 instead of 10.

%d can be negative.


