Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbaDCEV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 00:21:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47769 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbaDCEVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 00:21:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1393213435-20863-3-git-send-email-t.dakhran@samsung.com>
Cc: "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, "Rob Landley" <rob@landley.net>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Ben Dooks" <ben-linux@fluff.org>, "Tomasz Figa" <t.figa@samsung.com>,
        "Vyacheslav Tyrtov" <v.tyrtov@samsung.com>,
        "Thomas Abraham" <thomas.abraham@linaro.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Heiko Stuebner" <heiko@sntech.de>,
        "Romain Naour" <romain.naour@openwide.fr>,
        "Chander Kashyap" <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "Tarek Dakhran" <t.dakhran@gmail.com>,
        "Tarek Dakhran" <t.dakhran@samsung.com>
References: <1393213435-20863-1-git-send-email-t.dakhran@samsung.com>
 <1393213435-20863-3-git-send-email-t.dakhran@samsung.com>
Message-ID: <20140403042139.5762.23354@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v7 2/3] clk: exynos5410: register clocks using common clock
 framework
Date: Wed, 02 Apr 2014 21:21:39 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tarek Dakhran (2014-02-23 19:43:54)
> +External clock:
> +
> +There is clock that is generated outside the SoC. It is expected
> +that it is defined using standard clock bindings with following
> +clock-output-name:
> + - "fin_pll" - PLL input clock - required.

<snip>

> +Example 2: Required external clock.
> +
> +       fin_pll: clock-fin-pll {
> +               compatible = "fixed-clock";
> +               reg = <0>;
> +               #clock-cells = <0>;
> +               clock-frequency = <24000000>;
> +               clock-output-names = "fin_pll";
> +       };

I guess this part is a little strange for a binding definition.
Basically this is DTS data specific to 5410; not sure why it belongs in
the DT binding definition.

Rest of the clock driver appears OK to me.

Regards,
Mike
