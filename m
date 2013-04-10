Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab3DJK7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:59:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53362 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3DJK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:59:20 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-b8-51654606b22e
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: "'Simon Glass'" <sjg@chromium.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, linux@roeck-us.net,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-2-git-send-email-dianders@chromium.org>
In-reply-to: <1365543270-10736-2-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v5 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
Date: Wed, 10 Apr 2013 19:59:17 +0900
Message-id: <310301ce35da$724dff60$56e9fe20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac41ahQUnnt78Z2jQzeeXuZmiPdqAwAb/yjw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t8zA102t9RAgwMrBCwe3Gplsli29h+L
	xb/Zp9gs7j4/zGhxdtlBNovGGfNZLb58PcFm8erMRjaLywsvsVpsenyN1eLyrjlsFrcv81o8
	WXiGyeLU9c9sFqsOb2C3mLLoMKvFty3bGC0OPlzAbPHqYBuLxbEZSxgtbk+czGix8sQsZouH
	R7tZHcQ9Wpp72DxmN1xk8Xj2cjKTx85Zd9k97lzbw+axeUm9x5UTTaweLyf+ZvPo/2vgsfN7
	A7tH35ZVjB4/X+p4nDz1hMXj8yY5j41zQwP4o7hsUlJzMstSi/TtErgy/n1NK7gjXnG9+Rxz
	A+NmoS5GTg4JAROJzt//mCFsMYkL99azdTFycQgJLGOU2LfjMAtM0dX5M1khEtMZJTb/+Qzl
	/GWU+HNsM1gVm4CGxOH3z9hBbBEBf4lLS5aDjWIWWMQqcWrZbXaIjr2MEg92XWADqeIUcJOY
	e3Q2E4gtLBAg0fJ8B1icRUBVoqfnDNhUXgFbidl3frFB2IISPybfA4szC2hJrN95nAnClpfY
	vOYt0BMcQLeqSzz6qwtxhJFE+5QvUOUiEvtevGMEuUFCYDGnxJ9FL1khdglIfJt8iAWiV1Zi
	0wFoWEhKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yf
	u4kRkrom7mC8f8D6EGMy0PqJzFKiyfnA1JdXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaYNc/kjn/Zp39aOaZvVvxk1XWX/h7nWq18jr1jp9CD
	AtY572SnfkzVLmnxqDp46eH+iUYx8xcd8XXZevGqwt3s5LQo4+bnEg1BUaJK00K8ynODjsmF
	TnhXxntAdB9P7O/g6JcvP1qY7NncuSs4+D+Pnfa6NvGpMkZHGhhvb9Tt6/n56fMC6WglluKM
	REMt5qLiRAAf2B5VcwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA5VSe2xLURx2eu89vRPNrho7JpgrgkWnrdqOx4SguYKs9UgQyVzdtS7Wrno3
	TCTK5jUNpvPqiE6WicbMVhETr27GzDyHho0Yy2aEyTaPmS26Fln4y/nrO1++7/s98qMJ+RUY
	QSeb0wSrmU9hYX/yTs+bgQqoFfTK1uIQ/Or5dgkuLOohcU9eNcQvmisAvlvohXjrkRMU7vhc
	BfG7mhKIa/MfUbj0zVMK1146BnFdrQw35tdIcLWvHWJ3xTkpzj1ZQeEv5y8A7G1wEfiddweJ
	bx4pALguxwHw6SongRsq91Azw7msTDvk8mwPSa6pxSHhypwvpFz908uQ8xRs4R5XbaO4lpwu
	yO3rVnJlX21Sbu95N+A6WyZwt6sbSa69dARXcnypLnSFDUw3CnyiYI0UzIbUxGRzUhw7f3HC
	7ITJMUqVQjUFx7KRZt4kxLFzFugU2uQU/xLYyPV8Srqf0vGiyE6c8W/C0iVaBf5tXKZYuGTR
	H49a+ddbdRYYez6vsdSHb/Rl3iNswCPPBiE0YjToyYmjVBAPQQ9eFsNs0J+WM4cB8vxop4Kf
	boB+3PSQvSrIjEMVrU3SXhzGxKNHBacCDoI5SaHqwjpp0HEFoFeXHsBeVQijRccr8yS9eBCj
	Q1nNFwM8yYxBdntNIFXGxKG8+u8wiAeib46XAZ5golBx2S1JEI9EnjMfiGxA+3sdi153K4JN
	qNHO3I5f8jB09e1HsB/InX2SnH2SnH2SnH0sLkC6wWDBYrCIq5NM6miRN4np5qRoQ6qpFASO
	sWnYReC24XLA0IAdIHOpEvVyil8vZpjKAaIJNkyGowS9XJbIZ2wSrKkJ1vQUQSwHBv+gOUTE
	YEOq/7TNaQmqSZoY9RR1DFZrYmP/j2bDZd7t0/RyJolPE9YKgkWw/q4ioUMibEB3S2SGN0PN
	QfeNFVPPtBVN2OXt11HWFTqzaWWnYB+vfnZt6vXlZFf6BU2M475vjH30uDCWM2a1VhY1tue2
	+e7hjMkld6GP+pDpejLXQevf727bbIyOneWSfKy1VB06feDTpHnmQRvWeS2jWrIea42Hhu4Y
	skrTFdppVTaQNfEelhSNvCqKsIr8T8N5vGDQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> We need to use the i2c-arbitrator to talk to any of the devices on i2c
> bus 4 on exynos5250-snow so that we don't confuse the embedded
> controller (EC).  Add the i2c-arbitrator to the device tree.  As we
> add future devices (keyboard, sbs, tps65090) we'll add them on top of
> this.
> 
> The arbitrated bus is numbered 104 simply as a convenience to make it
> easier for people poking around to guess that it might have something
> to do with the physical bus 4.
> 
> The addition is split between the cros5250-common and the snow device
> tree file since not all cros5250-class devices use arbitration.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I'm fine on 2nd and 3rd patches. Shall I take only two patches without 1st
one in samsung tree?

- Kukjin

> ---
> Changes in v5:
> - Adjust bindings as per Wolfram Sang.
> 
> Changes in v4:
> - Changed mux gpio syntax to work atop Thomas's "ARM: dts: add pin
>   state information in client nodes for Exynos5 platforms"; avoid
>   adding gpios property to i2c@12CA0000 for the same reason.
> 
> Changes in v3: None
> Changes in v2:
> - Use new device tree property names / compatible string.
> - Include that the GPIOs for arbitration are active low.
> 
>  arch/arm/boot/dts/cros5250-common.dtsi |  3 ++-
>  arch/arm/boot/dts/exynos5250-snow.dts  | 25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/cros5250-common.dtsi
> b/arch/arm/boot/dts/cros5250-common.dtsi
> index 8a5b3a6..0a61bbb 100644
> --- a/arch/arm/boot/dts/cros5250-common.dtsi
> +++ b/arch/arm/boot/dts/cros5250-common.dtsi
> @@ -193,7 +193,8 @@
>  	};
> 
>  	i2c@12CA0000 {
> -		status = "disabled";
> +		samsung,i2c-sda-delay = <100>;
> +		samsung,i2c-max-bus-freq = <66000>;
>  	};
> 
>  	i2c@12CB0000 {
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
> b/arch/arm/boot/dts/exynos5250-snow.dts
> index 581ffae..fa85f58 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -16,6 +16,10 @@
>  	model = "Google Snow";
>  	compatible = "google,snow", "samsung,exynos5250";
> 
> +	aliases {
> +		i2c104 = &i2c_104;
> +	};
> +
>  	pinctrl@11400000 {
>  		sd3_clk: sd3-clk {
>  			samsung,pin-drv = <0>;
> @@ -44,6 +48,27 @@
>  		};
>  	};
> 
> +	i2c-arbitrator {
> +		compatible = "i2c-arb-gpio-challenge";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		i2c-parent = <&{/i2c@12CA0000}>;
> +
> +		our-claim-gpio = <&gpf0 3 1>;
> +		their-claim-gpios = <&gpe0 4 1>;
> +		slew-delay-us = <10>;
> +		wait-retry-us = <3000>;
> +		wait-free-us = <50000>;
> +
> +		/* Use ID 104 as a hint that we're on physical bus 4 */
> +		i2c_104: i2c@0 {
> +			reg = <0>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +	};
> +
>  	/*
>  	 * On Snow we've got SIP WiFi and so can keep drive strengths low
> to
>  	 * reduce EMI.
> --
> 1.8.1.3

