Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbbAYBRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 20:17:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59489 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbAYBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 20:17:41 -0500
Date: Sat, 24 Jan 2015 17:17:39 -0800 (PST)
Message-Id: <20150124.171739.2001690287677703044.davem@davemloft.net>
To: romain.perier@gmail.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: Re: [PATCH v2 0/4] net: stmmac: dwmac-rk: Fix phy regulator issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Jan 2015 17:17:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 20 Jan 2015 07:09:36 +0000

> This series fixes few issues in dwmac-rk:
> 
> 1. Voltage settings was hardcoded into the driver for the phy regulator.
>    The driver now uses the default voltage settings found in the devicetree,
>    which are applied throught the regulator framework.
> 2. The regulator name used to power on or power off the phy was put in the devicetree
>    variable "phy_regulator", which is not standard and added a lot of code for nothing.
>    The driver now uses the devicetree property "phy-supply" and the corresponding functions
>    to manipulate this regulator.
> 
> The corresponding devicetree files are also updated. As this new binding for
> rk3288 has not been released with any official kernel yet (not until 3.20),
> I don't need to care about keeping compatibility with the old non standard property.

Series applied to net-next, thanks.
