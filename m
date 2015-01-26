Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbbA0AjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:39:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46266 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbbA0AjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:39:01 -0500
Date: Mon, 26 Jan 2015 15:22:53 -0800 (PST)
Message-Id: <20150126.152253.1228699160011707119.davem@davemloft.net>
To: b.galvani@gmail.com
Cc: peppe.cavallaro@st.com, f.fainelli@gmail.com, dave.taht@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: add BQL support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421863647-20048-1-git-send-email-b.galvani@gmail.com>
References: <1421863647-20048-1-git-send-email-b.galvani@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 15:22:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beniamino Galvani <b.galvani@gmail.com>
Date: Wed, 21 Jan 2015 19:07:27 +0100

> Add support for Byte Queue Limits to the STMicro MAC driver.
> 
> Tested on a Amlogic S802 quad Cortex-A9 board, where the use of BQL
> decreases the latency of a high priority ping from ~12ms to ~1ms when
> the 100Mbit link is saturated by 20 TCP streams.
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Applied.
