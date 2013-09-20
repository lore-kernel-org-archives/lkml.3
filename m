Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3ITLp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:45:57 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:44448 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754537Ab3ITLpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:45:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2740:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3872:4321:5007:7652:8603:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0
X-HE-Tag: cable91_50795b1d8161c
X-Filterd-Recvd-Size: 1695
Message-ID: <1379677551.2021.25.camel@joe-AO722>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
From: Joe Perches <joe@perches.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: David Howells <dhowells@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Date: Fri, 20 Sep 2013 04:45:51 -0700
In-Reply-To: <523BDB55.2000008@att.net>
References: <1379482610.1787.7.camel@joe-AO722>
	 <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
	 <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
	 <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net>
	 <1379639226.5862.9.camel@joe-AO722> <523BDB55.2000008@att.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 00:21 -0500, Daniel Santos wrote:

[nice example about bloat]

> Yeah, I do agree, I just don't see how to do it without introducing 
> unnecessary bloat.

I think the code size cost of %pE is pretty trivial
compared to the log size/runtime cost.

I would not want to see it used generically.

