Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3CEXty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:49:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55994 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3CEXtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:49:52 -0500
MIME-Version: 1.0
In-Reply-To: <1360957573-864-3-git-send-email-dianders@chromium.org>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
 <1360957573-864-1-git-send-email-dianders@chromium.org> <1360957573-864-3-git-send-email-dianders@chromium.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 6 Mar 2013 08:49:32 +0900
Message-ID: <CAHfPSqDH3kk0t6RV1Mja+L4my+iNqkHcBgcJ9HmcT6XnBQpkmA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: Add sbs-battery for exynos5250-snow
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 February 2013 04:46, Doug Anderson <dianders@chromium.org> wrote:
> Now that we have i2c-arbitrator in place on bus 4 we can add the
> sbs-battery driver.  Future devices will be added onto bus 4 once
> drivers are in good shape.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
The patchset v3 is tested on snow with test case which uses i2c-4 from both
EC and AP side continuously for a more than a couple of minutes
> ---
> Changes in v3: None
> Changes in v2: None
>
>  arch/arm/boot/dts/exynos5250-snow.dts | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index d2d4b48..2127386 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -51,6 +51,12 @@
>                         reg = <0>;
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> +
> +                       battery: sbs-battery@b {
> +                               compatible = "sbs,sbs-battery";
> +                               reg = <0xb>;
> +                               sbs,poll-retry-count = <1>;
> +                       };
>                 };
>         };
>
> --
> 1.8.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Shine bright,
(: Nav :)
