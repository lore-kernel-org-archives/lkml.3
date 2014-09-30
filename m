Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaI3UYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:24:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaI3UYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:24:16 -0400
Date: Tue, 30 Sep 2014 16:24:13 -0400 (EDT)
Message-Id: <20140930.162413.1928220515698421769.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix setting RTL8152_UNPLUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-50-Taiwan-albertk@realtek.com>
References: <1394712342-15778-50-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 13:24:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 30 Sep 2014 16:48:01 +0800

> The flag of RTL8152_UNPLUG should only be set when the device is
> unplugged, not each time the rtl8152_disconnect() is called.
> Otherwise, the device wouldn't be stopped normally.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
