Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaLVV32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:29:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43647 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaLVV31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:29:27 -0500
Date: Mon, 22 Dec 2014 16:29:23 -0500 (EST)
Message-Id: <20141222.162923.1183357932658326852.davem@davemloft.net>
To: dg@emlix.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] net: s6gmac: remove driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419190059-16501-1-git-send-email-dg@emlix.com>
References: <20141111.113007.194586174190893576.davem@davemloft.net>
	<1419190059-16501-1-git-send-email-dg@emlix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Dec 2014 13:29:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>
Date: Sun, 21 Dec 2014 20:27:39 +0100

> The s6000 Xtensa support has been removed from the kernel in
> 4006e565e1500db4. There are no other chips using this driver.
> 
> While the Mentor/Alcatel PE-MCXMAC IP core is also used in other
> designs (Freescale Gianfar/UCC, QLogic NetXen, Solarflare, Agere
> ET-1310, Netlogic XLR/XLS), none of these use this driver as it
> heavily depends on the s6000 DMA engine. In fact, there is no
> code sharing across any of the aforementioned devices.
> 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>

Applied, thanks.
