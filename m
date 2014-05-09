Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbaEIV7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:59:54 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:38617 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757167AbaEIV7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:59:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3867:3870:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12257:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scale19_72eca96ce5834
X-Filterd-Recvd-Size: 1729
Message-ID: <1399672788.2912.32.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Warn on #defines ending in semicolon
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Andres Freund <andres@anarazel.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Andy Whitcroft <apw@canonical.com>
Date: Fri, 09 May 2014 14:59:48 -0700
In-Reply-To: <alpine.DEB.2.02.1405092345480.6261@ionos.tec.linutronix.de>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
	 <1399598957-7011-3-git-send-email-andres@anarazel.de>
	 <20140509075730.GB16058@pd.tnic> <20140509103303.GC16058@pd.tnic>
	 <1399671106.2912.21.camel@joe-AO725>
	 <alpine.DEB.2.02.1405092345480.6261@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 23:47 +0200, Thomas Gleixner wrote:
> On Fri, 9 May 2014, Joe Perches wrote:
> 
> > Using a #define ending in a semicolon is poor style
> 
> It's not poor style it's simply a bug. Just because it 
> 
> > can lead to unexpected code paths being executed.

I think it's still a (bad) style issue.

I remember a discussion with a developer that
wanted all macros to end in a semicolon so he
could write COBOL like C.

ick.

cheers, Joe


