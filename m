Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaGJHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:43:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:43:15 -0400
Date: Thu, 10 Jul 2014 00:43:14 -0700 (PDT)
Message-Id: <20140710.004314.1668741288285519292.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: support jumbo frame for RTL8153
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-9-Taiwan-albertk@realtek.com>
References: <1394712342-15778-8-Taiwan-albertk@realtek.com>
	<1394712342-15778-9-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 00:43:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 10 Jul 2014 10:58:54 +0800

> The maximum jumbo frame size for RTL8153 is 9K bytes.
> Change the max rx packet size to 9K.
> Change the use of the shared fifo from 6K (default) to 12K for tx.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
