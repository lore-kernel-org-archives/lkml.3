Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab3GJHCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:02:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47712 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3GJHCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:02:32 -0400
X-AuditID: cbfee68e-b7f276d000002279-f3-51dd070673c7
Message-id: <51DD0707.8010400@samsung.com>
Date: Wed, 10 Jul 2013 16:02:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH V2 2/4] extcon: palmas: enable ID_GND and ID_FLOAT
 detection always
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
 <1373436959-32444-3-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373436959-32444-3-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkUJeN/W6gwfP1NhYHZj9ktejf4mJx
	4WkPm8XSfatZLBa2LWGxuLxrDpvF7cYVbBbrXk5nceDweLV6JqvH+RkLGT16m9+xefRtWcXo
	MXXKX0aP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlbFsySm2gk7+inMH3RsYH/J0MXJySAiY
	SLzfv4MVwhaTuHBvPVsXIxeHkMBSRonrx6YxwhRNnreRHSIxnVGi4f5TJpCEkMArRonOefUg
	Nq+AlkTf9bfMIDaLgKrE2617wWrYgOL7X9xgA7FFBcIkVk6/wgJRLyjxY/I9MFsEqObbgX/M
	IAuYBTYxSqyaNgtskLBApMT/Nc1ANgfQsnqJ63drQExOAVeJP19VQCqYBXQk9rdOY4Ow5SU2
	r3kLNkZC4BG7RMuaU1D3CEh8m3yIBaRXQkBWYtMBZoi/JCUOrrjBMoFRbBaSi2YhGTsLydgF
	jMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj8fS/Z307GG8esD7EmAy0ciKzlGhyPjCe
	80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOD/u
	sziXQdLxBWI/1Z+u+JLTf0Du/Z/Xgrf3Lpn7aee/BLWeC3mmMo2Tc/ZGdGV/Svk5d4udz5YV
	a0u3lIkInf2izf2VrzI04wpXsoT5mUWLr+8veF8nFlRy2vCbx92/PKwT6lrWCJ+NtT+6lt/5
	+a5nz8sNv32e8qLqZekXA6v7E7kerjO4N1eJpTgj0VCLuag4EQDYRBXV3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQV029ruBBjenmFgcmP2Q1aJ/i4vF
	hac9bBZL961msVjYtoTF4vKuOWwWtxtXsFmsezmdxYHD49Xqmawe52csZPTobX7H5tG3ZRWj
	x9Qpfxk9jt/YzuTxeZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	ZUtOsRV08lecO+jewPiQp4uRk0NCwERi8ryN7BC2mMSFe+vZuhi5OIQEpjNKNNx/ygSSEBJ4
	xSjROa8exOYV0JLou/6WGcRmEVCVeLt1L1gNG1B8/4sbbCC2qECYxMrpV1gg6gUlfky+B2aL
	ANV8O/CPGWQBs8AmRolV02aBDRIWiJT4v6YZyOYAWlYvcf1uDYjJKeAq8eerCkgFs4COxP7W
	aWwQtrzE5jVvmScwCsxCsmEWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO
	9mfSOxhXNVgcYhTgYFTi4T2gcCdQiDWxrLgy9xCjBAezkgjvv0tAId6UxMqq1KL8+KLSnNTi
	Q4zJwACYyCwlmpwPTER5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cC4sOjelEKnXc0Ksta7f1zZNE/pTeY37/m5nQwPSnLO7c2UWqF1nuf3p7eWjApOLdas
	bns2S9Ymqfy2eMCUcPr4Zq2s8rzE3TfKuS1Dre2u3WC16FkYLB306VdjVHXhgpgfobcqRJ8u
	0f9nc+/izAOue28HOmhMvm7tx7Xt68Ov5y3F5Nav8RZUYinOSDTUYi4qTgQARmwi3DoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

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
> +		dev_info(palmas_usb->dev, "HOST cable is attached\n");
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
> +		dev_info(palmas_usb->dev, "HOST cable is detached\n");
> +	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
> +				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
> +		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
> +		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
> +		dev_info(palmas_usb->dev, "HOST cable is detached\n");
>  	}

After I modify info message when USB-HOST cable is attached or detached
as following mesesage, I applied this patch.

"HOST cable is ..." -> "USB-HOST cable is"

Thanks,
Chanwoo Choi

