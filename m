Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaLCQUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:20:25 -0500
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:54041 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053AbaLCQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:20:21 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2892:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3874:4362:5007:6261:7875:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chain62_59d11382e9f41
X-Filterd-Recvd-Size: 1422
Date: Wed, 3 Dec 2014 11:20:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
Message-ID: <20141203112015.19f6ff6c@gandalf.local.home>
In-Reply-To: <20141203043423.6c7e4524@gandalf.local.home>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<547ED753.3060508@hitachi.com>
	<20141203043423.6c7e4524@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 04:34:23 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> OK, I'll hold off on sending this patch then till 3.20.
> 

BTW, can we add another option that just shows the echo output. The -d
enables -x which floods the screen with lots of useless information and
it's hard to see what is going on.

Thanks,

-- Steve
