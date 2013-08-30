Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3H3Emp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:42:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58834 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755788Ab3H3Emm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:42:42 -0400
Message-ID: <1377837761.1928.139.camel@joe-AO722>
Subject: Re: [PATCH] USB2NET : SR9700 : One Chip USB 1.1 USB2NET SR9700
 Device Driver Support
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: liujunliang_ljl@163.com, davem@davemloft.net, horms@verge.net.au,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunhecheng@vip.126.com
Date: Thu, 29 Aug 2013 21:42:41 -0700
In-Reply-To: <20130829230644.GA12124@electric-eye.fr.zoreil.com>
References: <1377746832-6201-1-git-send-email-liujunliang_ljl@163.com>
	 <20130829230644.GA12124@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 01:06 +0200, Francois Romieu wrote:

just trivia:

> diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
[]
> @@ -288,19 +291,19 @@ static void sr9700_set_multicast(struct net_device *net)
[]
> +static int sr9700_set_mac_address(struct net_device *netdev, void *p)
[]
> -	memcpy(net->dev_addr, addr->sa_data, net->addr_len);
> -	sr_write_async(dev, PAR, 6, dev->net->dev_addr);
> +	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
> +	sr_write_async(dev, PAR, 6, netdev->dev_addr);

s/6/ETH_ALEN/
 

