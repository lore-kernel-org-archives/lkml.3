Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaETHtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:49:52 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50241 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaETHtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:49:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Max Schwarz <max.schwarz@online.de>, Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Date: Tue, 20 May 2014 09:53:16 +0200
Message-ID: <17296198.jKWxDrNG79@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1956748.HoDAyYWJMb@typ>
References: <5192968.EzcUiXba22@typ> <1956748.HoDAyYWJMb@typ>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. Mai 2014, 02:37:57 schrieb Max Schwarz:
> Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.
> 
> Configuration is only possible through devicetree. The driver is
> interrupt driven and supports the I2C_M_IGNORE_NAK mangling bit.
> 
> Signed-off-by: Max Schwarz <max.schwarz@online.de>

Acked-by: Heiko Stuebner <heiko@sntech.de>

