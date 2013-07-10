Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3GJCP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:15:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40310 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:15:57 -0400
X-AuditID: cbfee68e-b7f276d000002279-ae-51dcc3dbefab
Message-id: <51DCC3DA.3060402@samsung.com>
Date: Wed, 10 Jul 2013 11:15:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH 2/4] extcon: palmas: enable ID_GND and ID_FLOAT detection
 always
References: <1373375064-12012-1-git-send-email-ldewangan@nvidia.com>
 <1373375064-12012-3-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373375064-12012-3-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkQPf24TuBBlvWclgcmP2Q1aJ/i4vF
	hac9bBZL961msVjYtoTF4vKuOWwWtxtXsFmsezmdxYHD49Xqmawe52csZPTobX7H5tG3ZRWj
	x9Qpfxk9jt/YzuTxeZNcAHsUl01Kak5mWWqRvl0CV8bi9Z4Ff5Qq2rs6GRsYZ8l2MXJySAiY
	SLzZdocVwhaTuHBvPVsXIxeHkMBSRonmO09YYIqebLnBDGILCSxilFh80QWi6BWjxIwL39hA
	ErwCWhIX33axg9gsAqoS3Qe/gTWwAcX3v7gBViMqECaxcvoVFoh6QYkfk++B2SJANd8O/GMG
	GcossIlRYtW0WUAOB4cwUMPFI4oQi+slnnyfwghicwq4Spx5PB9sF7OAjsT+1mlsELa8xOY1
	b8HmSAjcY5f48uIaM8RBAhLfJh9iAZkpISArsekAM8RjkhIHV9xgmcAoNgvJSbOQjJ2FZOwC
	RuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIERefrfs74djDcPWB9iTAZaOZFZSjQ5HxjR
	eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgnLvz
	8criYi+vPDaNL6+3G//70D2tJjOZOel2eun3Y8smxCoa/zu+ue73+4CaxH6GvXP1+i5tXxtz
	bM+XO1YWW185XjqmX/VI4lqKgcb+//UxZ7r2/72/LTdtlfsn0Xqx82FMmwtafSxqfeUYL2r9
	jd1U9eDoG07TXvVvlSKaytd3/FjP+6Q8TomlOCPRUIu5qDgRANR77j/eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd1bh+8EGnw+Y2NxYPZDVov+LS4W
	F572sFks3beaxWJh2xIWi8u75rBZ3G5cwWax7uV0FgcOj1erZ7J6nJ+xkNGjt/kdm0ffllWM
	HlOn/GX0OH5jO5PH501yAexRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	Fq/3LPijVNHe1cnYwDhLtouRk0NCwETiyZYbzBC2mMSFe+vZQGwhgUWMEosvunQxcgHZrxgl
	Zlz4BpbgFdCSuPi2ix3EZhFQleg++A2smQ0ovv/FDbAaUYEwiZXTr7BA1AtK/Jh8D8wWAar5
	duAfM8hQZoFNjBKrps0Ccjg4hIEaLh5RhFhcL/Hk+xRGEJtTwFXizOP5YLuYBXQk9rdOY4Ow
	5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnC8P5Pa
	wbiyweIQowAHoxIP7wGFO4FCrIllxZW5hxglOJiVRHjzVgGFeFMSK6tSi/Lji0pzUosPMSYD
	Q2Ais5Rocj4wFeWVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A6OMwgY2rWhXg4VcJvO4RW13RyfdeV6e9kybYfYbLQYtpfs+P/K35Ejq/HU4suwIU5GjRoCg
	7Nc50tOObjrVo1PJuCdzmuG3vsNSiTd2PXk0TyxhmoRwwn5DHvHkKVP9NrGqVtqzOR98JLVJ
	7JCAypn324/3qyfcOfmH79T0tQec5ntv61ksJ6zEUpyRaKjFXFScCACazG2TOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On 07/09/2013 10:04 PM, Laxman Dewangan wrote:
> When integrating driver with Tegra platform, it is found that
> the ID pins get detected only once after booting system and
> further removal and re-insert does not detect the ID pin.
> 
> Fixing this issue with enabling interrupt on ID_GND and ID_FLOAT
> always  and clearing the status on LATCH register which actually
> occurred.
> 
> Also if interrupt occurs with line status as zero then based on
> previous status, set the cable state.
> 
> Add debug prints to display the cable state when any cable
> insertion/removal happen.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/extcon/extcon-palmas.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index b752a0a..587034b 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -57,6 +57,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>  		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
>  			palmas_usb->linkstat = PALMAS_USB_STATE_VBUS;
>  			extcon_set_cable_state(&palmas_usb->edev, "USB", true);
> +			dev_info(palmas_usb->dev, "USB cable state: TRUE\n");

I prfer following info message when USB cable is inserted.
dev_info(palmas_usb->dev, "USB cable is attached\n");


>  		} else {
>  			dev_dbg(palmas_usb->dev,
>  				"Spurious connect event detected\n");
> @@ -65,6 +66,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>  		if (palmas_usb->linkstat == PALMAS_USB_STATE_VBUS) {
>  			palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>  			extcon_set_cable_state(&palmas_usb->edev, "USB", false);
> +			dev_info(palmas_usb->dev, "USB cable state: FALSE\n");

ditto.
dev_info(palmas_usb->dev, "USB cable is detached\n");

>  		} else {
>  			dev_dbg(palmas_usb->dev,
>  				"Spurious disconnect event detected\n");
> @@ -84,28 +86,23 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>  
>  	if (set & PALMAS_USB_ID_INT_SRC_ID_GND) {
>  		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
> -			PALMAS_USB_ID_INT_EN_HI_SET,
> -			PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
> -			PALMAS_USB_ID_INT_EN_HI_CLR,
> -			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>  		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
>  		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
> +		dev_info(palmas_usb->dev, "HOST cable state: TRUE\n");

ditto.
dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");

>  	} else if (set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) {
>  		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
> -			PALMAS_USB_ID_INT_EN_HI_SET,
> -			PALMAS_USB_ID_INT_EN_HI_SET_ID_GND);
> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
> -			PALMAS_USB_ID_INT_EN_HI_CLR,
> -			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>  		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>  		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
> +		dev_info(palmas_usb->dev, "HOST cable state: FALSE\n");

ditto.
dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");

> +	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
> +				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
> +		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
> +		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
> +		dev_info(palmas_usb->dev, "HOST cable state: FALSE\n");

dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");

>  	}
>  
>  	return IRQ_HANDLED;
> @@ -122,7 +119,8 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
>  
>  	palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>  		PALMAS_USB_ID_INT_EN_HI_SET,
> -		PALMAS_USB_ID_INT_EN_HI_SET_ID_GND);
> +		PALMAS_USB_ID_INT_EN_HI_SET_ID_GND |
> +		PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
>  
>  	palmas_vbus_irq_handler(palmas_usb->vbus_irq, palmas_usb);
>  
> 

I you would modify info message, anything else is good.

Thanks,
Chanwoo Choi
