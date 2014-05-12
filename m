Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbaELRuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:50:32 -0400
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:35574 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753529AbaELRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:50:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3622:3865:3867:3873:3874:4321:5007:7652:7901:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13071:13132:13231:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: swim62_4010a07dbf15
X-Filterd-Recvd-Size: 1250
Message-ID: <1399917025.9240.16.camel@joe-AO725>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 12 May 2014 10:50:25 -0700
In-Reply-To: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 19:30 +0200, Fabian Frederick wrote:
> This patch also fixes some comment checkpatch warnings

Hello Fabian.

For all the patches that replace memcpy(foo, bar, ETH_ALEN)
with ether_addr_copy, did you use a tool to verify both
arguments are __aligned(2) or did you do the verification
visually?


