Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3HMJyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:54:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19178 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3HMJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:54:33 -0400
X-AuditID: cbfee691-b7fef6d000002d62-80-520a0257b46b
Message-id: <520A0257.1080903@samsung.com>
Date: Tue, 13 Aug 2013 18:54:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: benoit.cousson@linaro.org, tony@atomide.com, swarren@wwwdotorg.org,
        myungjoo.ham@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        george.cherian@ti.com, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 1/2] extcon: palmas: Added a new compatible type
 *ti,palmas-usb-vid*
References: <1376302675-15795-1-git-send-email-kishon@ti.com>
 <1376372241-15573-1-git-send-email-kishon@ti.com>
In-reply-to: <1376372241-15573-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsWyRsSkWDeciSvI4MBpFYuD9+stZn66yWYx
	/8g5VotTB5ezWjQvXs9m8aa3g8XiwtMeNotNj6+xWixsW8JicXnXHDaL2Uv6WSxuX+a1WHr9
	IpPF7cYVbBYTpq9lsTi84gCTxbqX01ksXh1sY7HYf8XLQdhjzbw1jB4tzT1sHt++TmLxWPD5
	CrvH68kTGD1erZ7J6nHn2h42j/1z17B7bF5S79G3ZRWjx/Eb25k8Pm+S89g4NzSAN4rLJiU1
	J7MstUjfLoEr4/eXRewFBwQrVr7IaGC8wtfFyMkhIWAi8WrSdCYIW0ziwr31bCC2kMBSRolF
	E1JhahYc/g0U5wKKT2eUOPtiLzOE84pR4uj5q2DdvAJaEnc7W8C6WQRUJXavO8wMYrMBxfe/
	uAEWFxUIk1g5/QoLRL2gxI/J98BsEaCa0zt/gA1lFjjJLPF72TKwhLBAlMSR5zNZIU4qlDh1
	/CPYIE4BO4mnLffBFjAL6Ejsb53GBmHLS2xe8xZskITADQ6JzmnzWCAuEpD4NvkQkM0BlJCV
	2HSAGeI1SYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxN
	jMCkcfrfs4k7GO8fsD7EmAy0ciKzlGhyPjDp5JXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMT0v5tV9HpeTy3lbuU/8zpOc8E77+cpocecdFq9u
	ZLVGOlmyKypM3fSd8/Slc9auR3/eUpD6mfmhfo0Jl+sRTfnQKcaXj61f9fbYXO6JnLxqBR9j
	b2XXZ2ks7557516yl9yrgmufdNw5mRQES/dz/fq9bAVDoOasrnt/H6oa6at9q7HsP7IlX4ml
	OCPRUIu5qDgRAIUxyTAwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd1wJq4ggwMrpSwO3q+3mPnpJpvF
	/CPnWC1OHVzOatG8eD2bxZveDhaLC0972Cw2Pb7GarGwbQmLxeVdc9gsZi/pZ7G4fZnXYun1
	i0wWtxtXsFlMmL6WxeLwigNMFuteTmexeHWwjcVi/xUvB2GPNfPWMHq0NPeweXz7OonFY8Hn
	K+werydPYPR4tXomq8eda3vYPPbPXcPusXlJvUffllWMHsdvbGfy+LxJzmPj3NAA3qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDeVFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBm/vyxiLzggWLHyRUYD4xW+LkZODgkB
	E4kFh3+zQdhiEhfurQeyuTiEBKYzSpx9sZcZwnnFKHH0/FUmkCpeAS2Ju50tYB0sAqoSu9cd
	Zgax2YDi+1/cAIuLCoRJrJx+hQWiXlDix+R7YLYIUM3pnT/AhjILnGSW+L1sGVhCWCBK4sjz
	mawgtpBAocSp4x/BBnEK2Ek8bbkPtoBZQEdif+s0NghbXmLzmrfMExgFZiHZMQtJ2SwkZQsY
	mVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCelZ1I7GFc2WBxiFOBgVOLhFXjPESTEmlhW
	XJl7iFGCg1lJhFfpD2eQEG9KYmVValF+fFFpTmrxIcZkYBBMZJYSTc4HJsy8knhDYxMzI0sj
	c0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA8deRocrB38LUEL7MXu6fb1GYw
	sRvYXRXhPvNqjVWOaAqnpzDLlCl+SZbdlg5RjIyeYVUvYoR5DyY/n/tiv9CraOl6w+avuv26
	Ml8+Cs57t1Qn1ioz3cC0dLKRu/cZ7/e3rr679kphTlTNq2sa09bPL8+deYW/aHv7rMybSp7t
	V7OPJh1JiFBiKc5INNRiLipOBACMqXshjgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 08/13/2013 02:37 PM, Kishon Vijay Abraham I wrote:
> The Palmas device contains only a USB VID detector, so added a
> compatible type *ti,palmas-usb-vid*. Dint remove the existing compatible
> types for backward compatibility.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/extcon/extcon-twl.txt |    3 ++-
>  drivers/extcon/extcon-palmas.c                          |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-twl.txt b/Documentation/devicetree/bindings/extcon/extcon-twl.txt
> index 58f531a..5be4afc 100644
> --- a/Documentation/devicetree/bindings/extcon/extcon-twl.txt
> +++ b/Documentation/devicetree/bindings/extcon/extcon-twl.txt
> @@ -2,7 +2,8 @@ EXTCON FOR TWL CHIPS
>  
>  PALMAS USB COMPARATOR
>  Required Properties:
> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
> + - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb" or
> +   "ti,palmas-usb-vid".
>   - vbus-supply : phandle to the regulator device tree node.
>  
>  Optional Properties:
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index b752a0a..4f83fae 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -223,6 +223,7 @@ static int palmas_usb_remove(struct platform_device *pdev)
>  
>  static struct of_device_id of_palmas_match_tbl[] = {
>  	{ .compatible = "ti,palmas-usb", },
> +	{ .compatible = "ti,palmas-usb-vid", },
>  	{ .compatible = "ti,twl6035-usb", },
>  	{ /* end */ }
>  };
> 

This patch has a conflict. You have to always implement patch on extcon branch
including latest patch. You need to resend v2 patch based on extcon-next branch.

'extcon-twl.txt' is renamed as 'extcon-palmas.txt' on following patch:
http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=80d644b297dc26c5126858555044edef76f4ffe8

And, 'vbus-supply' phandle was removed on following patch:
http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=26ece4f0b7d2264282d9077d1843ff1e98189b6c

Thanks,
Chanwoo Choi

