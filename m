Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaJCWjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:39:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60384 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaJCWjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:39:00 -0400
Date: Fri, 03 Oct 2014 15:40:59 -0700 (PDT)
Message-Id: <20141003.154059.1211808905920859149.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2] r8152: autoresume before setting MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-56-Taiwan-albertk@realtek.com>
References: <1394712342-15778-55-Taiwan-albertk@realtek.com>
	<1394712342-15778-56-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 15:38:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 2 Oct 2014 17:03:12 +0800

> Resume the device before setting the MAC address.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
