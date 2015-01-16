Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbbAPQhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:37:43 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:46848 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753858AbbAPQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:37:42 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:965:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3622:3866:3871:3873:3874:4362:4390:5007:6261:7514:7875:7901:7903:9040:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: doll26_2590679a1384f
X-Filterd-Recvd-Size: 1920
Date: Fri, 16 Jan 2015 11:37:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
Message-ID: <20150116113736.59406ea8@gandalf.local.home>
In-Reply-To: <1421415659.11734.131.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20150115171634.685237a4.akpm@linux-foundation.org>
	<20150115203045.00e9fb73@grimm.local.home>
	<alpine.DEB.2.11.1501152126300.13976@gentwo.org>
	<20150115225130.00c0c99a@grimm.local.home>
	<alpine.DEB.2.11.1501152155480.14236@gentwo.org>
	<20150115230749.5d73ad49@grimm.local.home>
	<1421415659.11734.131.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 05:40:59 -0800
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> I made same observation about 3 years ago, on old cpus.
> 

Thank you for letting me know. I was thinking I was going insane!

(yeah yeah, there's lots of people who will still say that I've already
gone insane, but at least I know my memory is still intact)

-- Steve
