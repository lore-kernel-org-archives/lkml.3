Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaHSSBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:01:54 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:55873 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753054AbaHSSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:01:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:7652:7903:8531:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fire63_2d2b7dd931a07
X-Filterd-Recvd-Size: 2421
Message-ID: <1408471308.23250.10.camel@joe-AO725>
Subject: Re: [PATCH v2] drivers: net: ethernet: intel: e1000:
 e1000_ethertoo.c coding style fixes
From: Joe Perches <joe@perches.com>
To: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2014 11:01:48 -0700
In-Reply-To: <53F38A84.3070702@vipserv.org>
References: <1408393263-18027-1-git-send-email-cristos@vipserv.org>
	 <CAL3LdT7+5FFbP5Rf1MoY2GJ9cQ0LJnecQb66ZA2ofwD28vy1jw@mail.gmail.com>
	 <53F38A84.3070702@vipserv.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 19:33 +0200, Krzysztof Majzerowicz-Jaszcz wrote:
> On 19/08/14 18:04, Jeff Kirsher wrote:
> > On Mon, Aug 18, 2014 at 3:21 PM, Krzysztof Majzerowicz-Jaszcz
> > <cristos@vipserv.org> wrote:
> >> Fixed many errors/warnings and checks in e1000_ethtool.c reported by checkpatch.pl
> >> Suggestions from Joe Perches and Alexander Duyck applied as well
> >>
> >> Signed-off-by: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
> >> ---
> >>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 155 ++++++++++++-----------
> >>  1 file changed, 79 insertions(+), 76 deletions(-)
> >>
> > 
> > Thanks Krzysztof, I will add your patch to my queue and I can fix up
> > the patch title for you. :-)
> >
> 
> Thank you :). Sorry for that patch title - I guess that 'first pancake is always spoiled'.
> Nonetheless, that makes my first successful contribution to the kernel <yay> ;)

Yay for Krzysztof.

Now you could fix the same "*(foo + bar) == 0xXX" uses
in drivers/net/ethernet/intel/e1000e/ethtool.c

drivers/net/ethernet/intel/e1000e/ethtool.c:	if (*(skb->data + 3) == 0xFF)
drivers/net/ethernet/intel/e1000e/ethtool.c:		if ((*(skb->data + frame_size / 2 + 10) == 0xBE) &&
drivers/net/ethernet/intel/e1000e/ethtool.c:		    (*(skb->data + frame_size / 2 + 12) == 0xAF))

as well if you wanted to follow up on your first success.


