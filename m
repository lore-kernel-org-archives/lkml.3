Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaCKCZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:25:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49526 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaCKCZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:25:21 -0400
Date: Mon, 10 Mar 2014 22:25:20 -0400 (EDT)
Message-Id: <20140310.222520.814414646267623877.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: add skb_cow_head
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394504432-998-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394504432-998-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 19:25:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 11 Mar 2014 10:20:32 +0800

> Call skb_cow_head() before editing the tx packet header. The header
> would be reallocated if it is shared.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
