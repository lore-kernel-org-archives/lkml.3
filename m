Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3AUW2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:28:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52003 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3AUW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:28:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/7] ARM: sunxi: Add pinctrl driver for Allwinner SoCs
Date: Mon, 21 Jan 2013 22:28:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Linus Walleij <linus.walleij@linaro.org>,
        Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com> <1358544639-14761-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1358544639-14761-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212228.25770.arnd@arndb.de>
X-Provags-ID: V02:K0:JMCnUh9Rcb44ZdIW9Yfm+2gFXM+Qu+X9XwToQvfxsKU
 ZaghWrWMi61a595pFtbSIUfer9GtGXR/w/ezxTUfbbFIE0NjCo
 FjOXjfIaNRFJlT+7UtjPW2/gRjG1EJttl3BuEZbqTpl39m8kXj
 aL4xpc7dVz9VJDJ2L0z3+hqSvUhN4K47DVY/9efROhOkTW6yoS
 GBRg3lHpAOPpi7cFdmXlBG50SCiWNrb20cJI7Br05cjSTyGLSs
 bawfQMucCLq48XOjkJdyTbj8iAhAnF62/8qydceiS2P78dakNz
 ZN2sMu6Z7GJcdFse2jJZG78KMMGixPRHeqDhdpT8KXGPuUTGa/
 iYEDnZrNxfcr/Xew9oWs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Maxime Ripard wrote:
> The Allwinner SoCs have an IP module that handle both the muxing and the
> GPIOs.
> 
> This IP has 8 banks of 32 bits, with a number of pins actually useful
> for each of these banks varying from one to another, and depending on
> the SoC used on the board.
> 
> This driver only implements the pinctrl part, the gpio part will come
> eventually.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
