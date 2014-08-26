Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbaHZA0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:26:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:25:59 -0400
Date: Mon, 25 Aug 2014 17:25:58 -0700 (PDT)
Message-Id: <20140825.172558.1917292824044947963.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com, mirqus@gmail.com
Subject: Re: [PATCH v6 1/4] net: moxa: clear DESC1 on ndo_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408976531-15589-1-git-send-email-jonas.jensen@gmail.com>
References: <1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
	<1408976531-15589-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:25:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Mon, 25 Aug 2014 16:22:11 +0200

> TX buffer length is not cleared on ndo_start_xmit().
> Failing to do so can bug/hang the controller and
> cause TX interrupts to stop altogether.
> 
> Remove the readl() and compute a new value for DESC1.
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=69031
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied.
