Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaJHH6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:58:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62429 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJHH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:58:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH 4/6] ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC
Date: Wed, 08 Oct 2014 09:58:12 +0200
Message-ID: <1996601.jhvNxNYxnl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412746025-11998-5-git-send-email-sbranden@broadcom.com>
References: <1412746025-11998-5-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b6NhzUGmdbOl5/04uU/Td538aCSTPxwdhbSCsnlLY0q
 NB1bFwOULBVWsvRa4Hucs98aLqbZvtMrEIfGaOGNN/bnlVHj92
 DNDmrHbBGDjbn5uQrWQV+Wnt/m/+M5pMCBft7Qhxw2HGiNHY/I
 4Ks2EPUhV8rUjXYpunUaCjeZNNP9wJeNCVQ1QRbnpm1uHobP0Z
 Hm0PTnIZRLmN5YZxGcyRmCa6nC+zV7ST6U3HSwExO3gnenu68G
 rhMNr0RxImOEC2lzC13DXU9DHGH6fl5xa+0vybAg/wUMUF0ph0
 7OjIXzCYVvNGb57ulnVuT9KlfhEkAAqOLfRXJVWgfktPZHyCIx
 xyu45SK367m5vD2QsXgI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 22:27:03 Scott Branden wrote:
> From: Jonathan Richardson <jonathar@broadcom.com>
> 
> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>

Do you actually need a separate defconfig?

If possible, just add your drivers to multi_v7_defconfig, otherwise
include a justification in the patch changelog why your platform
should have its own defconfig file.

	Arnd
