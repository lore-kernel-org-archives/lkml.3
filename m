Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbbAUIdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:33:01 -0500
Received: from gloria.sntech.de ([95.129.55.99]:40086 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbbAUIcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:32:53 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: Re: [PATCH v2 0/4] net: stmmac: dwmac-rk: Fix phy regulator issues
Date: Wed, 21 Jan 2015 09:32:38 +0100
Message-ID: <1791081.FUojULYATz@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Januar 2015, 07:09:36 schrieb Romain Perier:
> This series fixes few issues in dwmac-rk:
> 
> 1. Voltage settings was hardcoded into the driver for the phy regulator.
>    The driver now uses the default voltage settings found in the devicetree,
> which are applied throught the regulator framework.
> 2. The regulator name used to power on or power off the phy was put in the
> devicetree variable "phy_regulator", which is not standard and added a lot
> of code for nothing. The driver now uses the devicetree property
> "phy-supply" and the corresponding functions to manipulate this regulator.
> 
> The corresponding devicetree files are also updated. As this new binding for
> rk3288 has not been released with any official kernel yet (not until 3.20),
> I don't need to care about keeping compatibility with the old non standard
> property.

This series
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>

@Dave: as said in the v1 mail, this would be nice to have for 3.20
