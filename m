Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbaGYGiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:38:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaGYGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:38:09 -0400
Date: Thu, 24 Jul 2014 23:38:07 -0700 (PDT)
Message-Id: <20140724.233807.867041649917385199.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrey.krieger.utkin@gmail.com
Subject: Re: [PATCH net] r8152: fix the checking of the usb speed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-15-Taiwan-albertk@realtek.com>
References: <1394712342-15778-15-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:38:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 24 Jul 2014 16:37:43 +0800

> When the usb speed of the RTL8152 is not high speed, the USB_DEV_STAT[2:1]
> should be equal to [0 1]. That is, the STAT_SPEED_FULL should be equal
> to 2.
> 
> There is a easy way to check the usb speed by the speed field of the
> struct usb_device. Use it to replace the original metheod.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Applied, thanks.
