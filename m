Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaI3O3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:29:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55707 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647AbaI3O2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:28:53 -0400
Date: Tue, 30 Sep 2014 16:28:50 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: David Miller <davem@davemloft.net>
Cc: antoine.tenart@free-electrons.com, sebastian.hesselbarth@gmail.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/10] net: pxa168_eth: add device tree support
Message-ID: <20140930142850.GA30288@kwain>
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411742036-23520-3-git-send-email-antoine.tenart@free-electrons.com>
 <20140929.160436.1932620234954504510.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140929.160436.1932620234954504510.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Sep 29, 2014 at 04:04:36PM -0400, David Miller wrote:
> From: Antoine Tenart <antoine.tenart@free-electrons.com>
> Date: Fri, 26 Sep 2014 16:33:48 +0200
> 
> > @@ -1603,6 +1620,12 @@ static int pxa168_eth_suspend(struct platform_device *pdev, pm_message_t state)
> >  #define pxa168_eth_suspend NULL
> >  #endif
> >  
> > +static const struct of_device_id pxa168_eth_of_match[] = {
> > +	{ .compatible = "marvell,pxa168-eth" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, pxa168_eth_of_match)
> > +
> >  static struct platform_driver pxa168_eth_driver = {
> 
> You didn't even compile test this change with module support enabled.
> 
> drivers/net/ethernet/marvell/pxa168_eth.c:1670:1: error: expected ‘,’ or ‘;’ before ‘static’
> 
> MODULE_DEVICE_TABLE() must be completed with a trailing ';'

Oops, thanks for spotting this!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
