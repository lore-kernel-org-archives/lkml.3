Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3KLQag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:30:36 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:38120 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753869Ab3KLQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:30:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2692:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4321:4605:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12555:12740:13069:13160:13229:13311:13357:13848,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brake31_78fee9b922e04
X-Filterd-Recvd-Size: 1930
Message-ID: <1384273839.4771.49.camel@joe-AO722>
Subject: Re: scripts: checkpatch.pl & Lindent (minor complaint)
From: Joe Perches <joe@perches.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 08:30:39 -0800
In-Reply-To: <1384272557.5754.30.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1384271045.4771.47.camel@joe-AO722>
	 <1384272557.5754.30.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 11:09 -0500, Mimi Zohar wrote:
> On Tue, 2013-11-12 at 07:44 -0800, Joe Perches wrote:
> > On Tue, 2013-11-12 at 09:42 -0500, Mimi Zohar wrote: 
> > > scripts/Lindent and scripts/checkpatch disagree whether the fields in a
> > > statically initialized array should be blank separated.  
> > > 
> > > static struct ima_rule_entry default_rules[] = {
> > >         {.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
> > > 
> > > Lindent adds a blank before '.fsmagic', which checkpatch then complains
> > > about (eg. commit 75834fc3).
> > 
> > Perhaps I don't understand what you mean.
> 
> > Lindent _doesn't_add a blank and checkpatch
> > seems to do the right thing here.
> 
> Sorry, my mistake.  It's the reverse.  Checkpatch complains about the
> missing blank, which Lindent then removes.

My suggestion is not to use Lindent.

If you want a semi-automated source-code reformatting tool,
use scripts/checkpatch.pl --fix


