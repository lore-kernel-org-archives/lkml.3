Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaDLGBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 02:01:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33584 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaDLGBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 02:01:22 -0400
Date: Sat, 12 Apr 2014 02:01:20 -0400 (EDT)
Message-Id: <20140412.020120.1042243807724903382.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, sejeong.na@samsung.com
Subject: Re: [PATCH net] r8152: check RTL8152_UNPLUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-4-Taiwan-albertk@realtek.com>
References: <1394712342-15778-4-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 23:01:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 11 Apr 2014 17:54:31 +0800

> When the device is unplugged, the driver would try to disable the
> device. Add checking the flag of RTL8152_UNPLUG to skip setting
> the device when it is unplugged. This could shorten the time of
> unloading the driver.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
