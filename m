Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106AbaCSQsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:48:08 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:59895 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbaCSQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:48:05 -0400
Message-ID: <5329CA2A.8030309@elopez.com.ar>
Date: Wed, 19 Mar 2014 13:47:38 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dinh Nguyen <dinh.linux@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: stmmac-socfpga breakage in arm-soc
References: <201403191333.01095.arnd@arndb.de> <4337501.shzGE38xmF@wuerfel> <5329AAE1.7030705@gmail.com> <29079107.ja9Hu9mMY0@wuerfel>
In-Reply-To: <29079107.ja9Hu9mMY0@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

El 19/03/14 11:58, Arnd Bergmann escribió:
(snip)
> diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
> index 5748351..19d5648 100644
> --- a/Documentation/devicetree/bindings/net/stmmac.txt
> +++ b/Documentation/devicetree/bindings/net/stmmac.txt
> @@ -31,6 +31,10 @@ Optional properties:
>   - reset-names: Should contain the reset signal name "stmmaceth", if a
>   	reset phandle is given
>   - max-frame-size: See ethernet.txt file in the same directory
> +- clocks: If present, the first clock should be the GMAC main clock,
> +  further clocks may be specified in derived bindings
> +- clock-names: One name for each entry in the clocks property, the
> +  first one should be "stmmaceth".
>
>   Examples:
>
> @@ -43,4 +47,6 @@ Examples:
>   		mac-address = [000000000000]; /* Filled in by U-Boot */
>   		max-frame-size = <3800>;
>   		phy-mode = "gmii";
> +		clocks = <&clock>;
> +		clock-names = "stmmaceth">

There's a small typo there on the ;

Cheers,

Emilio
