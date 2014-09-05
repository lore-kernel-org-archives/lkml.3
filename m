Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaIETSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:18:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54991 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIETSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:18:06 -0400
Date: Fri, 05 Sep 2014 12:18:05 -0700 (PDT)
Message-Id: <20140905.121805.2149838652698517913.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] r8152: random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-32-Taiwan-albertk@realtek.com>
References: <1394712342-15778-26-Taiwan-albertk@realtek.com>
	<1394712342-15778-32-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 12:18:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 4 Sep 2014 16:15:40 +0800

> If the interface has invalid MAC address, it couldn't
> be used. In order to let it work normally, give a
> random one.
> 
> v3:
>   Remove
> 	ether_addr_copy(dev->perm_addr, dev->dev_addr);
> 
> v2:
>   Use "%pM" format specifier for printing a MAC address.

Series applied, thanks.
