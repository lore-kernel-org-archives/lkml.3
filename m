Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3GOXD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:03:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56793 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3GOXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:03:28 -0400
X-AuditID: cbfee68e-b7f276d000002279-28-51e47fbebf96
Message-id: <51E47FBE.5030700@samsung.com>
Date: Tue, 16 Jul 2013 08:03:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] extcon: palmas: remove assigning "edev.name" to palmas
References: <1371215904-2189-1-git-send-email-kishon@ti.com>
In-reply-to: <1371215904-2189-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkRHdf/ZNAgzsL9CwO3q+3uPC0h83i
	8q45bBa3G1ewObB49G1Zxehx/MZ2Jo/Pm+QCmKO4bFJSczLLUov07RK4MpY+eMtYsJCrom3X
	PdYGxgscXYycHBICJhLfH/xngbDFJC7cW8/WxcjFISSwlFFi8buLbDBFDatvghUJCSxilPjY
	5ABR9IpR4vzuP4wgCV4BLYnpC/6BNbAIqErMf/eYFcRmA4rvf3EDLC4qECaxcvoVFoh6QYkf
	k++B2SJANad3/mAGsZkFPCQu7T7FDmILC3hLTGzbw9TFyAG0zEai71oGSJhTwFZi471DjBDl
	OhL7W6exQdjyEpvXvGUGuU1CYBm7xInLe1kh7hGQ+Db5EAvIHAkBWYlNB5gh/pKUOLjiBssE
	RrFZSC6ahWTsLCRjFzAyr2IUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIjKDT/5717WC8ecD6
	EGMy0MqJzFKiyfnACMwriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA6N3+uEIh+Ntkgmbn1+b6Kpo1x2nUhT2q8VBQkbq+6kzB/tl5gXvStUJf6K4
	oXXJVbPJE/eJL5v86Aj7Mx2N3Mn/PihsCfrH5ZOv510wZdPcLL+4u/pMv5V2pKtnyBitfVR4
	NJfrr0HrfvWQ/bqP3FWyJfvbJTZdkBdVW+3Xvt3g4ZUFaZI96UosxRmJhlrMRcWJAAOFBbi2	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xgO6++ieBBmu/qVkcvF9vceFpD5vF
	5V1z2CxuN65gc2Dx6NuyitHj+I3tTB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMGYsffCWsWAhV0XbrnusDYwXOLoYOTkkBEwkGlbfZIGwxSQu3FvPBmILCSxi
	lPjY5NDFyAVkv2KUOL/7DyNIgldAS2L6gn9gRSwCqhLz3z1mBbHZgOL7X9wAi4sKhEmsnH6F
	BaJeUOLH5HtgtghQzemdP5hBbGYBD4lLu0+xg9jCAt4SE9v2MHUxcgAts5Hou5YBEuYUsJXY
	eO8QI0S5jsT+1mlsELa8xOY1b5knMArMQrJhFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIjs9n0jsYVzVYHGIU4GBU4uE9yPkkUIg1say4MvcQowQHs5IIr50wUIg3JbGy
	KrUoP76oNCe1+BBjMjAAJjJLiSbnA1NHXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwpqtLvfvKc9n8izyjtPC0qNtr1i4NvBpxTTaR57PP43S+TQ+UqzzZ
	7Rz5mkRy2veenvjukJbICbvFazNZ/6g1/rupHsFbuuxI9Yrnwb/TL7M1m63azT1x43L9TVln
	tfe4ZUvsnnR3VeLFlBrf4zlLHsm6bJzKrrHId8UZBzW5f04yNysW/fTxVGIpzkg01GIuKk4E
	AObQvJsTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:18 PM, Kishon Vijay Abraham I wrote:
> of_extcon_get_extcon_dev() uses dev_name for getting the reference
> to the extcon device. If the extcon driver assigns a different
> name other than dev_name, of_extcon_get_extcon_dev() wouldn't
> be able to find the reference to the extcon device. Since the
> client drivers of extcon-palmas would be using
> of_extcon_get_extcon_dev(), removed assigning edev.name
> in extcon-palmas.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/extcon/extcon-palmas.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index b752a0a..7350ac2 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -172,7 +172,6 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, palmas_usb);
>  
> -	palmas_usb->edev.name = "palmas-usb";
>  	palmas_usb->edev.supported_cable = palmas_extcon_cable;
>  	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
>  
> 

This patch is applied. Sorry for missing this patch.
You can check it on extcon-linus repo.
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/log/?h=extcon-linus

Thanks,
Chanwoo Choi
