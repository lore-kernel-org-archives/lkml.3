Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaG3LZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:25:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60333 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaG3LZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:25:22 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: Enable USB host0 (EHCI) on rk3288-evb
Date: Wed, 30 Jul 2014 13:26:38 +0200
Message-ID: <4280303.LVm1cg0Iss@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1406676273-20701-4-git-send-email-dianders@chromium.org>
References: <1406676273-20701-1-git-send-email-dianders@chromium.org> <1406676273-20701-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Juli 2014, 16:24:33 schrieb Doug Anderson:
> This is the top USB port on the evb (the one closest to the Ethernet
> connector).
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

shouldn't the signed-offs be the other way around, like in patch 2/3?

> ---
>  arch/arm/boot/dts/rk3288-evb.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
> b/arch/arm/boot/dts/rk3288-evb.dtsi index efd625e..fcdc64e 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -90,3 +90,7 @@
>  		};
>  	};
>  };
> +
> +&usb_host0_ehci {
> +	status = "okay";
> +};

