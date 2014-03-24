Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaCXCsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:48:47 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14757 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbaCXCsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:48:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 24 Mar 2014 10:48:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: vf610-twr: Add PWM0's pinctrl node
Message-ID: <20140324024818.GA10184@dragon>
References: <1395292325-8497-1-git-send-email-Li.Xiubo@freescale.com>
 <1395292325-8497-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1395292325-8497-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 01:12:04PM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Patch #2 and #3 can be reasonably merged into one.

Shawn

> ---
>  arch/arm/boot/dts/vf610-twr.dts | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
> index f3af8ea..3fabdb5 100644
> --- a/arch/arm/boot/dts/vf610-twr.dts
> +++ b/arch/arm/boot/dts/vf610-twr.dts
> @@ -213,6 +213,17 @@
>  			>;
>  		};
>  
> +		pinctrl_pwm0: pwm0grp {
> +			fsl,pins = <
> +				VF610_PAD_PTB0__FTM0_CH0		0x1582
> +				VF610_PAD_PTB1__FTM0_CH1		0x1582
> +				VF610_PAD_PTB2__FTM0_CH2		0x1582
> +				VF610_PAD_PTB3__FTM0_CH3		0x1582
> +				VF610_PAD_PTB6__FTM0_CH6		0x1582
> +				VF610_PAD_PTB7__FTM0_CH7		0x1582
> +			>;
> +		};
> +
>  		pinctrl_sai2: sai2grp {
>  			fsl,pins = <
>  				VF610_PAD_PTA16__SAI2_TX_BCLK		0x02ed
> -- 
> 1.8.4
> 
> 

