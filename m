Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaJNTeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:34:00 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:33393 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754278AbaJNTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:33:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3870:3871:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13095:13311:13357:14040:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flame16_225e45378d856
X-Filterd-Recvd-Size: 1763
Message-ID: <1413315062.10221.1.camel@joe-AO725>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Joe Perches <joe@perches.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <20141014191815.GB12662@arch.hh.imgtec.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <20141014143902.GA9768@arch.hh.imgtec.org>
	 <1413299343.7906.103.camel@sauron.fi.intel.com>
	 <20141014184702.GA12662@arch.hh.imgtec.org>
	 <1413314020.26864.7.camel@joe-AO725>
	 <20141014191815.GB12662@arch.hh.imgtec.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 14 Oct 2014 12:31:02 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4-0ubuntu2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 16:18 -0300, Ezequiel Garcia wrote:
> On 14 Oct 12:13 PM, Joe Perches wrote:
> > On Tue, 2014-10-14 at 15:47 -0300, Ezequiel Garcia wrote:
[]
> > > When the gendisk is not available, a simple pr_{} would work.
> > 
> > Or maybe combine these in the ubi_<level> calls passing
> > NULL when there is no struct ubi_device *
[]
> Isn't this excessive obfuscation? What's the benefit of it?

Single error message type.

