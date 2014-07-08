Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaGHScF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:32:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53255 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaGHScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:32:03 -0400
Date: Tue, 08 Jul 2014 11:32:02 -0700 (PDT)
Message-Id: <20140708.113202.326542398099281937.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: increase the tx timeout
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404359748-4202-1-git-send-email-hayeswang@realtek.com>
References: <1404359748-4202-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 11:32:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 3 Jul 2014 11:55:48 +0800

> When the system is too busy to complete the urb, the tx timout function
> would be called. This causes the other tx urbs would be killed, too.
> Increase the tx timeout to avoid it.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thank you.
