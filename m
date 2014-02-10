Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaBJC6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:58:39 -0500
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:60076 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752277AbaBJC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:58:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3151:3352:3622:3865:3866:3867:3871:4250:4321:5007:6119:7652:9165:10004:10400:10848:11026:11473:11658:11914:12517:12519:12681:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tax25_10925270a710d
X-Filterd-Recvd-Size: 2324
Message-ID: <1392001112.3178.15.camel@joe-AO722>
Subject: Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800
 Device Driver Support
From: Joe Perches <joe@perches.com>
To: liujunliang_ljl@163.com
Cc: davem@davemloft.net, horms@verge.net.au, romieu@fr.zoreil.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunhecheng@vip.126.com
Date: Sun, 09 Feb 2014 18:58:32 -0800
In-Reply-To: <1391755365-9202-1-git-send-email-liujunliang_ljl@163.com>
References: <1391755365-9202-1-git-send-email-liujunliang_ljl@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 14:42 +0800, liujunliang_ljl@163.com wrote:

> +		netdev_dbg(dev->net, "Write IPG,IPG1,IPG2 failed: %d", ret);
[]
> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x after all initializations",
[]
> +	netdev_dbg(dev->net, "Medium Status : 0x%04x after all initializations",
[]
> +		netdev_dbg(dev->net, "Select PHY #1 failed: %d", ret);
[]
> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x after software reset", rx_ctl);
[]
> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x setting to 0x0000", rx_ctl);
[]
> +	memcpy(data->mac_addr, dev->net->dev_addr, ETH_ALEN);

ether_addr_copy

> +		netdev_err(dev->net, "Failed to power down PHY : %d", ret);
[]
> +		netdev_err(dev->net, "Failed to reset PHY: %d", ret);
[]
> +		netdev_err(dev->net, "Failed to power up PHY: %d", ret);
[]
> +		netdev_err(dev->net, "Failed to reset PHY: %d", ret);
[]
> +			netdev_err(dev->net, "set LINK LED failed : %d", ret);
[]
> +		netdev_dbg(dev->net, "Failed to read MAC address: %d", ret);
[]
> +		netdev_dbg(dev->net, "Select PHY #1 failed: %d", ret);
[]
> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x after software reset", rx_ctl);
[]
> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x setting to 0x0000", rx_ctl);
[]
> +	netdev_dbg(dev->net, "PHYID=0x%08x", phyid);

Please make sure all of the netdev_<level> uses have a '\n'
line termination.

