Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab3LIRWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:22:22 -0500
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:35456 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759146Ab3LIRWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:22:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2904:3138:3139:3140:3141:3142:3622:3865:3867:3870:3872:4321:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12291:12517:12519:12683:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twist57_6b550dfa01b32
X-Filterd-Recvd-Size: 1261
Message-ID: <1386609736.8168.3.camel@joe-AO722>
Subject: Re: [PATCH 0/3] softirq: possible speedup and neatenings
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Mon, 09 Dec 2013 09:22:16 -0800
In-Reply-To: <cover.1384656563.git.joe@perches.com>
References: <cover.1384656563.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 01:55 -0800, Joe Perches wrote:
> The first one boots, but it's barely tested.
> 
> Joe Perches (3):
>   softirq: Use ffs in __do_softirq
>   softirq: Convert printks to pr_<level>
>   softirq: Use const char * const for softirq_to_name, whitespace neatening
> 
>  include/linux/interrupt.h |  2 +-
>  kernel/softirq.c          | 75 +++++++++++++++++++++--------------------------
>  2 files changed, 35 insertions(+), 42 deletions(-)

ping?

