Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab3LFV0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:26:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42698 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab3LFV0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:26:35 -0500
Date: Fri, 06 Dec 2013 16:26:33 -0500 (EST)
Message-Id: <20131206.162633.125107323851595113.davem@davemloft.net>
To: wens@csie.org
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        srinivas.kandagatla@st.com, maxime.ripard@free-electrons.com
Subject: Re: [PATCH 03/10] net: stmmac: Use platform data tied with
 compatible strings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386350983-13281-4-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
	<1386350983-13281-4-git-send-email-wens@csie.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 13:26:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>
Date: Sat,  7 Dec 2013 01:29:36 +0800

> +	device = of_match_device(stmmac_dt_ids, &pdev->dev);
> +	if (!device)
> +		return -ENODEV;
> +
> +	if (device->data)
> +	    memcpy(plat, device->data, sizeof(*plat));
> +

Don't invent your own indentation using spaces, this memcpy()
call is not indented properly, it should be two TABs.
