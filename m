Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaLVVbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:31:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43670 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaLVVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:31:09 -0500
Date: Mon, 22 Dec 2014 16:31:07 -0500 (EST)
Message-Id: <20141222.163107.1023158393448021294.davem@davemloft.net>
To: wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 10/28] net: ethernet: stmicro: stmmac: drop owner
 assignment from platform_drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419196495-9626-11-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	<1419196495-9626-11-git-send-email-wsa@the-dreams.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Dec 2014 13:31:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>
Date: Sun, 21 Dec 2014 22:14:31 +0100

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied, thanks.
