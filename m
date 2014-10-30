Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbaJ3Uzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:55:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59322 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaJ3Uzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:55:46 -0400
Date: Thu, 30 Oct 2014 16:55:44 -0400 (EDT)
Message-Id: <20141030.165544.2129434076908845307.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: set RTL8152_UNPLUG when finding -ENODEV
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-73-Taiwan-albertk@realtek.com>
References: <1394712342-15778-73-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 13:55:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 30 Oct 2014 11:46:40 +0800

> Set RTL8152_UNPLUG when finding -ENODEV. This could accelerate
> unloading the driver when the device is unplugged.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
