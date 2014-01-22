Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaAVNCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:02:36 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:45696 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755153AbaAVNC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:02:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6117:6119:6248:6691:7652:7903:7974:8527:10004:10400:10848:11232:11658:11914:12114:12517:12519:12679:12740:13069:13160:13161:13163:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.
X-HE-Tag: work04_6c756c772df3c
X-Filterd-Recvd-Size: 2288
Message-ID: <1390395744.31946.45.camel@joe-AO722>
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, alan@linux.intel.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Wed, 22 Jan 2014 05:02:24 -0800
In-Reply-To: <20140122122728.GA8882@gmail.com>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
	 <1390325069.2472.78.camel@joe-AO722> <20140122122728.GA8882@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 13:27 +0100, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
[]
> You have cut out my main argument from you reply and have ignored it:
 
Not ignored.  Threaded email works fine.

Your main argument is that some people don't cc lkml
because section entries don't specify it explicitly.

My main argument, which you elided, is that some people
will not cc lkml because they will see some sections
with L: entries with lkml and others without, and will
therefore _not_ cc lkml instead.

So I think the rule should be either every section has
an lkml entry or no section does.

Pick one.

Mixing styles just causes a different type of error.

> Which is not a very honest way to conduct discussions :-(
[]
> > MAINTAINERS already says:
> 
> That's irrelevant really, reality tells us that good people are 
> looking at the entries and are using them as-is. For such things 
> technology should adapt to people, not the other way around.

If you are going to complain about "honesty in
argumentation", try it yourself.

Be an exemplar.

Describing a previous change as being made for
intuitions sake when it wasn't, isn't.

cheers, Joe

