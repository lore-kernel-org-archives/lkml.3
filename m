Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaLUO0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:26:32 -0500
Received: from gloria.sntech.de ([95.129.55.99]:43805 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaLUO0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:26:31 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: Fix clock gate for rk3188 hclk_emem_peri
Date: Sun, 21 Dec 2014 15:26:22 +0100
Message-ID: <202741351.urIaKyAj2C@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418406639-13668-1-git-send-email-romain.perier@gmail.com>
References: <1418406639-13668-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Dezember 2014, 17:50:39 schrieb Romain Perier:
> Do not disable clock gate "hclk_emem_peri", otherwise EMAC clocks no longer
> work and it breaks ethernet on RK3066 and RK3188. It fixes a regression
> introduced by commit 78eaf6095cc763c1a228ebac5682852f04e85205 ("clk:
> rockchip: disable unused clocks").
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>

applied to my clk fixes branch for 3.19


Heiko
