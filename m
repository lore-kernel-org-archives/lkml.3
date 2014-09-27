Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaI0FsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 01:48:17 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:56547 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156AbaI0FsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 01:48:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4321:5007:7652:8957:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: money11_820419504bf41
X-Filterd-Recvd-Size: 1610
Message-ID: <1411796891.21874.14.camel@joe-AO725>
Subject: Re: [PATCH v3 1/2] Return a value from printk_ratelimited
From: Joe Perches <joe@perches.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 22:48:11 -0700
In-Reply-To: <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
References: <cover.1411796033.git.osandov@osandov.com>
	 <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 22:36 -0700, Omar Sandoval wrote:
> printk returns an integer; there's no reason for printk_ratelimited to swallow
> it.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

I'd prefer to keep it the way it is actually.

I've submitted several patches to convert the int return
to void for printk derived functions recently.


