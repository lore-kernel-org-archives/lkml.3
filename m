Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbbAHWSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:18:23 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:59250 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754999AbbAHWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:18:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:421:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3872:3873:4321:5007:6119:6261:7903:8957:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dad39_48568c6a6fe32
X-Filterd-Recvd-Size: 1183
Message-ID: <1420755495.11784.15.camel@perches.com>
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
From: Joe Perches <joe@perches.com>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Thu, 08 Jan 2015 14:18:15 -0800
In-Reply-To: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
References: <y> <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 14:03 -0800, Stephen Wang wrote:
> This driver adds support for the internal GMACs on IPQ806x SoCs.
> It supports the device-tree and will register up to 4 ethernet
> interfaces.

Trivial:

You might try running the code through checkpatch.


