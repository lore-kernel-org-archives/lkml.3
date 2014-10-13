Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaJMO4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:56:43 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:35513 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753272AbaJMO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:56:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3872:3874:4184:4321:5007:7514:7652:8957:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13255:13311:13357:19904:19999:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fight13_1d18ee4532047
X-Filterd-Recvd-Size: 1826
Message-ID: <1413212198.1287.9.camel@joe-AO725>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing
 forward declarations.
From: Joe Perches <joe@perches.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>, devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 13 Oct 2014 07:56:38 -0700
In-Reply-To: <CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
References: <20141013023425.GA15452@devel>
	 <20141013032544.GA26646@kroah.com>
	 <CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 17:01 +0900, DaeSeok Youn wrote:
> Hi,
> 
> 2014-10-13 12:25 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> > On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
> >> Re-arrange the functions for removing forward declarations.
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> This patch has too many changes for re-arranging the functions.
> >> So I wonder that I should break this up into smaller patches.
> >
> > Are the .o files identical before and after this patch?  If so, it's
> > fine.
> Ok. I will check for that.

The .o files shouldn't be identical after function reordering.

