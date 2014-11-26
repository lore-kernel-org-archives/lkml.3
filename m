Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaKZWwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:52:37 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58720 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:52:36 -0500
MIME-Version: 1.0
In-Reply-To: <1416900743-29204-5-git-send-email-zyw@rock-chips.com>
References: <1416900743-29204-1-git-send-email-zyw@rock-chips.com>
	<1416900743-29204-5-git-send-email-zyw@rock-chips.com>
Date: Wed, 26 Nov 2014 14:52:35 -0800
X-Google-Sender-Auth: Mw8SgOJp1c64mn3qOCBt3UpjnJM
Message-ID: <CAD=FV=V29zCpcEHE+rq6q_6SOZ_NOJgc5FiwmJ9jnRZK4mMUhw@mail.gmail.com>
Subject: Re: [PATCH v9 4/4] ARM: dts: rockchip: add suspend settings for rk3288-evb-rk808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Mon, Nov 24, 2014 at 11:32 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>                         vcc_ddr: DCDC_REG3 {
>                                 regulator-always-on;
>                                 regulator-boot-on;
>                                 regulator-name = "vcc_ddr";
> +                               regulator-suspend-mem-enabled;

The "regulator-suspend-mem-enabled" is not an upstream property and
isn't doing anything.  It should be removed.

Possibly this is something Heiko could do when applying  (depends on
what he wants) if no other spins are required.
>                         vcc_18: LDO_REG7 {
> @@ -128,6 +163,11 @@
>                                 regulator-min-microvolt = <1800000>;
>                                 regulator-max-microvolt = <1800000>;
>                                 regulator-name = "vcc_18";
> +                               regulator-suspend-mem-microvolt = <1800000>;

Another non-upstream property: regulator-suspend-mem-microvolt
