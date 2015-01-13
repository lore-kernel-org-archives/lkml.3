Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbbAMCmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:42:50 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:44417 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752732AbbAMCms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:42:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:4321:5007:6261:6742:8957:9038:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steam55_8c4d798aab131
X-Filterd-Recvd-Size: 1732
Message-ID: <1421116962.9233.17.camel@perches.com>
Subject: Re: [PATCH v4 1/2] watchdog: Add driver for Mediatek watchdog
From: Joe Perches <joe@perches.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, greta.zhang@mediatek.com,
        eddie.huang@mediatek.com, wens@csie.org, linux@roeck-us.net
Date: Mon, 12 Jan 2015 18:42:42 -0800
In-Reply-To: <1421076884-15860-2-git-send-email-matthias.bgg@gmail.com>
References: <1421076884-15860-1-git-send-email-matthias.bgg@gmail.com>
	 <1421076884-15860-2-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 16:34 +0100, Matthias Brugger wrote:
> This patch adds a driver for the Mediatek SoC integrated
> watchdog. This driver supports watchdog and software reset
> for mt65xx and mt81xx SoCs.

trivia:

> diff --git a/drivers/watchdog/mtk_wdt.c b/drivers/watchdog/mtk_wdt.c
[]
> +static int mtk_wdt_probe(struct platform_device *pdev)
> +{
[]
> +	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",

missing terminating \n newline


