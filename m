Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaAFG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:59:27 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:43142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbaAFG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:59:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3876:3877:5007:6114:6312:6642:7652:10004:10400:10848:11026:11658:11914:12517:12519:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave22_5206c556c8f28
X-Filterd-Recvd-Size: 1245
Message-ID: <1388991562.5808.39.camel@joe-AO722>
Subject: Re: [PATCH net-next 3/3] r8152: replace the return value of
 rtl_ops_init
From: Joe Perches <joe@perches.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Sun, 05 Jan 2014 22:59:22 -0800
In-Reply-To: <1388990366-8508-4-git-send-email-hayeswang@realtek.com>
References: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
	 <1388990366-8508-4-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
[]
> @@ -2721,18 +2722,20 @@ static bool rtl_ops_init(struct r8152 *tp, const struct usb_device_id *id)
[]
> +	if (ret)
> +		netif_err(tp, probe, tp->netdev, "Unknown Device");

This format should have a terminating newline
"Unknown Device\n"


