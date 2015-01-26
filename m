Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbbAZTjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:39:52 -0500
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:39625 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753975AbbAZTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:39:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6119:6261:6691:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cook16_1b3b5acb72b40
X-Filterd-Recvd-Size: 2015
Message-ID: <1422301185.18650.4.camel@perches.com>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
From: Joe Perches <joe@perches.com>
To: Stathis Voukelatos <stathis.voukelatos@linn.co.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, abrestic@chromium.org
Date: Mon, 26 Jan 2015 11:39:45 -0800
In-Reply-To: <54C620CB.3010500@linn.co.uk>
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>
	 <1422135432.18650.2.camel@perches.com> <54C620CB.3010500@linn.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 11:11 +0000, Stathis Voukelatos wrote:
> On 24/01/15 21:37, Joe Perches wrote:
> > On Fri, 2015-01-23 at 10:07 +0000, Stathis Voukelatos wrote:
> >> This patch adds support the Ethernet Packet Sniffer H/W module
> >> developed by Linn Products Ltd and found in the IMG Pistachio SoC.
> >> The module allows Ethernet packets to be parsed, matched against
> >> a user-defined pattern and timestamped. It sits between a 100M
> >> Ethernet MAC and PHY and is completely passive with respect to
> >> Ethernet frames.
> > []
> >>   include/linux/pkt_sniffer.h                        |  89 +++++
> > Why should this file be here?
> > Why not in the drivers/net/pkt-sniffer directory?
[]
> This header file is the public API for the driver.
> Should it not live under the 'include' directory?
> Several other drivers seem to follow that convention.

It depends on how public is public.

If it's _really_ public, it should be in uapi.
If it's kinda public, then _maybe_ it should be
in include/linux, but how likely is it another
driver will use it?


