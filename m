Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaKRTic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:38:32 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53581 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaKRTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:38:30 -0500
Message-ID: <546BA032.1000903@gmail.com>
Date: Tue, 18 Nov 2014 20:38:26 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 13/13] ARM: dts: berlin: enable USB on the Google Chromecast
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com> <1416231347-27193-14-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1416231347-27193-14-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 14:35, Antoine Tenart wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Enable usb1 on Google Chromecast which is connected to micro-USB
> plug used for external power supply, too.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied to berlin/dt.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2cd-google-chromecast.dts | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> index bcd81ffc495d..5c42c3bfb613 100644
> --- a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> +++ b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> @@ -27,3 +27,7 @@
>   };
>
>   &uart0 { status = "okay"; };
> +
> +&usb_phy1 { status = "okay"; };
> +
> +&usb1 { status = "okay"; };
>

