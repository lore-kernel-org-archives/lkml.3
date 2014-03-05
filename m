Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbaCEPaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:30:10 -0500
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:46972 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753486AbaCEPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:30:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:3874:4321:5007:7652:10004:10400:10848:10967:11026:11232:11473:11658:11914:12296:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain71_3a3cfc9512e22
X-Filterd-Recvd-Size: 1558
Message-ID: <1394033397.3271.54.camel@joe-AO722>
Subject: Re: [PATCH 2/3] sched: Use clamp() and clamp_val() to make it more
 readable.
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, mingo@redhat.com,
        Kees Cook <keescook@chromium.org>
Date: Wed, 05 Mar 2014 07:29:57 -0800
In-Reply-To: <20140305102658.4c7ffe2c@gandalf.local.home>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <0b02fa0f05c9cebca19cadce92cb8c85ee130ce0.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <1394032656.3271.51.camel@joe-AO722>
	 <20140305102658.4c7ffe2c@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 10:26 -0500, Steven Rostedt wrote:
> On Wed, 05 Mar 2014 07:17:36 -0800 Joe Perches <joe@perches.com> wrote:
[]
> > or add yet another define like #define NICE_RANGE
> > or #define NICE_MAX_INCREMENT
> 
> Sure, if there's a NICE_MAX_INC == 40, then we could do:
> 
> 	increment = clamp(increment, -NICE_MAX_INC, NICE_MAX_INC);

Apologies for the noise.
He did that in the next patch.



