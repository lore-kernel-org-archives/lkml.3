Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbbAXKRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:17:43 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34393 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbbAXKRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:17:41 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: Re: [PATCH v2 1/4] net: stmmac: dwmac-rk: Don't set the regulator voltage for phy from the driver
Date: Sat, 24 Jan 2015 11:17:20 +0100
Message-ID: <6351287.4ner65dylF@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421737780-1533-2-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com> <1421737780-1533-2-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Januar 2015, 07:09:37 schrieb Romain Perier:
> As these settings can be directly expressed from devicetree for both fixed
> regulators and pmic-integrated regulators, it is more standard to set them
> from dts and let the regulator framework use the right voltage informations
> when it is used in the driver.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>

Romain suggested to resend my tags against a real patch of the series, so it 
turns up in patchwork, so

This series
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>

@Dave: as said in the v1 mail, this would be nice to have for 3.20


Heiko
