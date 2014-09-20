Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaITJ4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 05:56:07 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:53958 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaITJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 05:56:04 -0400
Message-ID: <541D4F2E.9020707@gmail.com>
Date: Sat, 20 Sep 2014 11:55:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ARM: mvebu: armada-xp: Add I2C eeprom on Lenovo ix4-300d
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <1411157684-6991-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-8-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 10:14 PM, Sebastian Hesselbarth wrote:
> There is an I2C eeprom connected on Lenovo ix4-300d, add the
> corresponding node.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
...
> ---
>  arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> index c5ee6c00766c..cef50da88e45 100644
> --- a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> +++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> @@ -98,6 +98,11 @@
>  					reg = <0x2e>;
>  				};
>  
> +				at24c64@50 {

nit: the node name should describe function, not its type.

@Jason, when you take this in, feel free to name the node eeprom@50
instead.

Sebastian

> +					compatible = "atmel,24c64";
> +					reg = <0x50>;
> +				};
> +
>  				pcf8563@51 {
>  					compatible = "nxp,pcf8563";
>  					reg = <0x51>;
> 

