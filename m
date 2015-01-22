Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbAVJc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:32:59 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:49554 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbAVJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:32:44 -0500
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Olliver Schinagl <o.schinagl@ultimaker.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH v2 4/4] leds: no longer use unnamed gpios
Date: Thu, 22 Jan 2015 10:32:35 +0100
Message-ID: <2355733.gZvsF3iKWH@pcimr>
User-Agent: KMail/4.14.3 (Linux/3.13.6; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com>
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com> <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2015 22:33:48 Olliver Schinagl wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
> 
> The gpio document says we should not use unnamed bindings for gpios.
> This patch uses the 'led-' prefix to the gpios and updates code and
> documents. Because the devm_get_gpiod_from_child() falls back to using
> old-style unnamed gpios, we can update the code first, and update
> dts files as time allows.
> 
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

Where does devm_get_gpiod_from_child() fall back "to using old-style
unnamed gpios"?

After applying this patch the leds defined in my devicetree do not
work anymore.

   Rojhalat


