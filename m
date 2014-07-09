Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaGIC77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:59:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaGIC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:59:57 -0400
Date: Tue, 08 Jul 2014 19:59:57 -0700 (PDT)
Message-Id: <20140708.195957.83100573934289236.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH net] r8169: disable L23
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-6-Taiwan-albertk@realtek.com>
References: <1394712342-15778-6-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 19:59:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 8 Jul 2014 16:26:10 +0800

> For RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106, the nic couldn't
> leave the power saving mode of L23 for certain situation. This causes
> the device lost for the system. Disable the L23 mode to avoid it.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

I agree with Francois, you need to provide a more detailed changelog
for this patch.
