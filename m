Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaLKHGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:06:19 -0500
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:40898 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933864AbaLKHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:06:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:4321:5007:6261:6742:10004:10226:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21060:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brain86_537c7f2d58c0a
X-Filterd-Recvd-Size: 1992
Message-ID: <1418281568.18092.34.camel@perches.com>
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Joe Perches <joe@perches.com>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, heiko@sntech.de,
        jwerner@chromium.org, dianders@chromium.org, olof@lixom.net,
        huangtao@rock-chips.com, zyw@rock-chips.com, cf@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Date: Wed, 10 Dec 2014 23:06:08 -0800
In-Reply-To: <54893F26.5050304@rock-chips.com>
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com>
	 <1418208371-18851-2-git-send-email-lyz@rock-chips.com>
	 <5489338C.1030109@ti.com> <1418278322.18092.30.camel@perches.com>
	 <54893963.7060304@ti.com> <1418279847.18092.32.camel@perches.com>
	 <54893F26.5050304@rock-chips.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 14:52 +0800, Yunzhi Li wrote:
> On 2014/12/11 14:37, Joe Perches wrote:
> > On Thu, 2014-12-11 at 11:57 +0530, Kishon Vijay Abraham I wrote:
[]
> >> So If I have to write something on bit 0, I have to set bit 16.
> >> If I have to write something on bit 1, I have to set bit 17.
> >> If I have to write something on bit 2, I have to set bit 18.
> >> and so on.
> > To me it'd look better to use another << rather than a plus
> Like (BIT(13) << 16)? It looks strange, or could I just use ((1 << 13) 
> << 16) to describe this bit ?

Up to you.  To me, the BIT(x+y) seems odd.


