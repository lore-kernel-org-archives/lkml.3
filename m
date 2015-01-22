Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbAVORd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:17:33 -0500
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:38226 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751146AbbAVORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:17:30 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3622:3865:3868:3871:5007:6261:7514:7875:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: event33_23f5edbd34100
X-Filterd-Recvd-Size: 1684
Date: Thu, 22 Jan 2015 09:17:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.cz>,
        Simon =?UTF-8?B?S8OlZ3N0csO2bQ==?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>, Dan Streetman <ddstreet@ieee.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org (open list),
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] printk: Add dummy routine for when
 CONFIG_PRINTK=n
Message-ID: <20150122091725.6f1d8222@gandalf.local.home>
In-Reply-To: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 21:26:08 -0500
Pranith Kumar <bobby.prani@gmail.com> wrote:

> There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
> for when CONFIG_PRINTK is not set causing build failures.
> 
> This patch adds these dummy routines at the appropriate location.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Michael Ellerman <mpe@ellerman.id.au>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
