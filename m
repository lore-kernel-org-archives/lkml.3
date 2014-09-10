Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaIJOG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:06:58 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:33183 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751717AbaIJOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:06:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3870:3873:3874:4321:4605:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: yard73_1def7715522e
X-Filterd-Recvd-Size: 1603
Message-ID: <1410358011.24028.43.camel@joe-AO725>
Subject: Re: [PATCH] tracing: fix typo in pr_warning() message
From: Joe Perches <joe@perches.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 07:06:51 -0700
In-Reply-To: <20140910090521.GA7766@hercules>
References: <1410299369-20029-1-git-send-email-luis.henriques@canonical.com>
	 <1410301213.22675.4.camel@joe-AO725> <20140910090521.GA7766@hercules>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 10:05 +0100, Luis Henriques wrote:
> On Tue, Sep 09, 2014 at 03:20:13PM -0700, Joe Perches wrote:
> > On Tue, 2014-09-09 at 22:49 +0100, Luis Henriques wrote:
> > > Replace 'produciton' by 'production'
[]
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
[]
> > > @@ -2028,7 +2028,7 @@ void trace_printk_init_buffers(void)
> > > -	pr_warning("** unsafe for produciton use.                           **\n");
> > > +	pr_warning("** unsafe for production use.                           **\n");
[]
> > Perhaps s/pr_warning/pr_warn/ too?
> 
> If you (and the maintainers) agree, I would rather do that in a
> separate commit.

Of course.


