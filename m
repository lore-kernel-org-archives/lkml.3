Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaAUV2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:28:24 -0500
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:33805 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754196AbaAUVZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3870:3873:4321:5007:7652:8531:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fold77_50ee5ed12db40
X-Filterd-Recvd-Size: 1597
Message-ID: <1390339554.31946.6.camel@joe-AO722>
Subject: Re: [PATCH] drivers/hid/wacom: fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rob Schroer <sulamiification@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Jan 2014 13:25:54 -0800
In-Reply-To: <20140121211823.GD29615@core.coreip.homeip.net>
References: <20140121195153.GA4198@fedora.fritz.box>
	 <20140121200645.GC29615@core.coreip.homeip.net>
	 <20140121202944.GA4554@fedora.fritz.box>
	 <20140121211823.GD29615@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 13:18 -0800, Dmitry Torokhov wrote:
> On Tue, Jan 21, 2014 at 09:29:44PM +0100, Rob Schroer wrote:
> > As far as I can see, kstrtoXXX() might be an alternative, but I was just
> > fixing coding style issues, no need to break anything IMO.
> 
> You could do the breaking in a follow up patch ;)

Yes please.

Include the breaking of multiple statements
into multiple lines too please like

from:
	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
		rep_data[0] = 0x03; rep_data[1] = 0x00;

to:
	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
		rep_data[0] = 0x03;
		rep_data[1] = 0x00;


