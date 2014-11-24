Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaKXE5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:57:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaKXE5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:57:34 -0500
Date: Sun, 23 Nov 2014 23:57:06 -0500 (EST)
Message-Id: <20141123.235706.1877570472649367521.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8152: use ECM mode for future chips
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-101-Taiwan-albertk@realtek.com>
References: <1394712342-15778-101-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Nov 2014 20:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 24 Nov 2014 11:09:47 +0800

> For the future chips which the r8152 doesn't support yet, we could
> still use ECM mode for basic transmission.

Gross, please don't do this.
