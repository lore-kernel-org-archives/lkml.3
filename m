Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161643Ab3LFXb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:31:57 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56036 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161029Ab3LFXbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:31:55 -0500
Message-ID: <52A25E66.6040403@free-electrons.com>
Date: Sat, 07 Dec 2013 00:31:50 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: brian@crystalfontz.com, jimwall@q.com, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: mxs: add #io-channel-cells to mx28 lradc
References: <1386361231-20427-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1386361231-20427-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit message should have been:

Adding #io-channel-cells property to lradc allows us to use the lradc as
an iio provider.

On 06/12/2013 21:20, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/imx28.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index cda19c8b0a47..92d9f9e33bf1 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -945,6 +945,7 @@
>  						20 21 22 23 24 25>;
>  				status = "disabled";
>  				clocks = <&clks 41>;
> +				#io-channel-cells = <1>;
>  			};
>  
>  			spdif: spdif@80054000 {


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

