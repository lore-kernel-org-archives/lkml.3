Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJ0Cvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:51:48 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:39069 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751957AbaJ0Cvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:51:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:4321:4605:5007:6119:6261:7903:9149:10004:10400:10848:11026:11232:11658:11914:12043:12295:12438:12517:12519:12555:12683:12740:13069:13311:13357:14095:14096:14110:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bead02_2c841cc64611d
X-Filterd-Recvd-Size: 2225
Message-ID: <1414378304.15751.26.camel@perches.com>
Subject: Re: [LKP] [rcu] BUG: kernel_boot_hang mode:0x10d0
From: Joe Perches <joe@perches.com>
To: kernel test robot <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 26 Oct 2014 19:51:44 -0700
In-Reply-To: <20141027020415.GC27038@yliu-dev.sh.intel.com>
References: <20141027020415.GC27038@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 10:04 +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> 
> commit eea203fea3484598280a07fe503e025e886297fb ("rcu: Use pr_alert/pr_cont for printing logs")
> 
> 
> +------------------------------------------------------------------+------------+------------+
> |                                                                  | 188c1e896c | eea203fea3 |
> +------------------------------------------------------------------+------------+------------+
> | boot_successes                                                   | 0          | 2          |
> | boot_failures                                                    | 15         | 13         |
> | page_allocation_failure:order:,mode:x10d0                        | 15         | 13         |
> | Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 15         |            |
> | backtrace:ring_buffer_consumer_thread                            | 15         | 13         |
> | backtrace:rcu_torture_stats                                      | 15         |            |
> | BUG:kernel_boot_hang                                             | 0          | 13         |
> +------------------------------------------------------------------+------------+------------+

I've no good idea why this change should cause any issue.


