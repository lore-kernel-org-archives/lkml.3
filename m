Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JVQzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:55:16 -0400
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:52911 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754046Ab3JVQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:55:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:334:355:368:369:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3872:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit21_848526662184e
X-Filterd-Recvd-Size: 1294
Message-ID: <1382460908.2041.94.camel@joe-AO722>
Subject: Re: [PATCH 1/3] kbuild: Increase kallsyms max symbol length
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Tue, 22 Oct 2013 09:55:08 -0700
In-Reply-To: <20131022164026.GE29695@two.firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
	 <1382456783-22826-2-git-send-email-andi@firstfloor.org>
	 <1382459764.2041.90.camel@joe-AO722>
	 <20131022164026.GE29695@two.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 18:40 +0200, Andi Kleen wrote:
> > Doesn't doubling seems a tad excessive given the
> > silly length of that symbol above?
> 
> No, it doesn't.

Does it work?

Doesn't kallsyms:get_symbol_offset restrict the maximum
possible length to 255?


