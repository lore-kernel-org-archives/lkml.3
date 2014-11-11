Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaKKIew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:34:52 -0500
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:39808 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751544AbaKKIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:34:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:2917:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:5007:6119:6261:7875:7903:8603:8825:9036:10004:10400:10848:11232:11473:11658:11914:12517:12519:12740:13069:13095:13132:13231:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: screw17_814494471f652
X-Filterd-Recvd-Size: 2117
Message-ID: <1415694886.16070.3.camel@perches.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Joe Perches <joe@perches.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 00:34:46 -0800
In-Reply-To: <5461C7C6.6060604@codeaurora.org>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
	 <5460F7D8.2030100@nod.at> <1415642273.8868.8.camel@perches.com>
	 <5461C7C6.6060604@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 10:24 +0200, Tanya Brokhman wrote:
> On 11/10/2014 7:57 PM, Joe Perches wrote:
> > On Mon, 2014-11-10 at 18:37 +0100, Richard Weinberger wrote:
> >> Am 03.11.2014 um 14:58 schrieb Tanya Brokhman:
> >>> If there is more then one UBI device mounted, there is no way to
> >>> distinguish between messages from different UBI devices.
> >>> Add device number to all ubi layer message types.
> >
> > Adding "error" and "warning" to the message logs is
> > duplicative to the KERN_<LEVEL> logging information.
> >
> >>> Changes from V5:
> >>> 	- Added ptr verification @ ubi_err/ubi_msg/ubi_warn
> >>> 	Removed extra printing of ubi number
> >>> 	Removed new messages.
> >
> > Did you all ever look at what I posted?
> 
> I did. Its not my place to re-post your change in my patch. I personally 
> prefer it the way I've done it but it's just a matter of opinion and 
> personal preference.

Don't forget object code size.


