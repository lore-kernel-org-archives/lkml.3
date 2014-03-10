Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaCJQt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:49:26 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:39591 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753756AbaCJQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:49:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:4321:4385:5007:7652:7875:7974:8828:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13071:13095:13311:13357:13894:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: food31_1743bb34f8d5e
X-Filterd-Recvd-Size: 2601
Message-ID: <1394470158.24244.18.camel@joe-AO722>
Subject: Re: [PATCH] cpufreq: Reformat printk() statement
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 10 Mar 2014 09:49:18 -0700
In-Reply-To: <f29b7db5-e5a2-48d8-ae42-8ec562c4c4f6@CO9EHSMHS025.ehs.local>
References: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
	 <CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
	 <1394424432.30791.11.camel@joe-AO722>
	 <f29b7db5-e5a2-48d8-ae42-8ec562c4c4f6@CO9EHSMHS025.ehs.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 09:35 -0700, Sören Brinkmann wrote:
> Hi Joe,

Hello Sören:

> On Sun, 2014-03-09 at 09:07PM -0700, Joe Perches wrote:
> > On Mon, 2014-03-10 at 11:53 +0800, Viresh Kumar wrote:
> > > On 7 March 2014 01:34, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > > > Reformat a printk statement to:
> > > >  - use pr_warn
> > > >  - bring the whole string into a single line in favor of being able to
> > > >    grep for the message (ignoring the 80 char limit)
> > > >
> > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > []
> > > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > 
> > A more comprehensive patch would be to:
> > 
> > Add missing newlines
> > Coalesce format fragments
> > Convert printks to pr_<level>
> > Align arguments
> 
> I agree. But I didn't want to spend time on "fixing" formatting without
> knowing it will be accepted. Also, I was grepping for the message I
> ended up changing because on an issue I actually needed to fix.
> 
> Do you want me to squash your changes into the patch I submitted? Or do
> you wanna pick up mine and submit your patch?

What I sent incorporates your change.

If Viresh or Rafael want me to sign it, I will,

Original-patch-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Joe Perches <joe@perches.com>

otherwise, feel free to resend it with your signature.

cheers, Joe


