Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaJVJEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:04:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51528 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJVJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:04:39 -0400
X-AuditID: cbfee68f-f791c6d000004834-72-5447730d435f
Message-id: <5447730E.80500@samsung.com>
Date: Wed, 22 Oct 2014 18:04:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH RESEND 2/3] extcon: max77693: Request only specific
 interrupts
References: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
 <1413967540-27626-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1413967540-27626-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkRJe32D3E4PMSK4uNM9azWrx+YWhx
	tukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHjcubaHzWPeyUCPvi2rGD0+b5ILYIni
	sklJzcksSy3St0vgylg2V6rgrVTF5K1L2BsYJ4p1MXJySAiYSKy/08YCYYtJXLi3nq2LkYtD
	SGApo8TB90dZYIo2PfzOCJFYxCix+sZzKOc1o8SB82fBqngFNCS2Hl7IBmKzCKhKvFkIEWcT
	0JLY/+IGWFxUIExi5fQrUPWCEj8m3wOzRQQMJQ7u3s4EMpRZYDmTxMNX85hBEsICIRLd7R+h
	bmpllJi3/QIjSIJTwEPi7Y8/7CA2s4COxP7WaWwQtrzE5jVvmUEaJASOsUsc+vCMCeIkAYlv
	kw8BreMASshKbDrADPGbpMTBFTdYJjCKzUJy1CwkY2chGbuAkXkVo2hqQXJBcVJ6kbFecWJu
	cWleul5yfu4mRmDUnf73rH8H490D1ocYBTgYlXh4HdjcQ4RYE8uKK3MPMZoCXTGRWUo0OR8Y
	23kl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamB0XJfb
	n7pAkXvt69/6061PrvyRt4ShY/dyFuudlR2bT82x9yr6F2SgtWnjNPuW2A7tuB1VJseafYQs
	Yz67sljOLdn1znS55wSvGOFVXx9Ka2V+OVE/cZ0229P82PIrXQ/fH2t/Ib/H7Kbb6mPTq1cK
	7Mtikn5mOGPtQ58Y9YVuP+9veFs2Q+eOEktxRqKhFnNRcSIAUj6uy7UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAV3eYvcQg94eI4uNM9azWrx+YWhx
	tukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHjcubaHzWPeyUCPvi2rGD0+b5ILYIlq
	YLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpCSaEs
	MacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixbK5UwVupislbl7A3ME4U62Lk
	5JAQMJHY9PA7I4QtJnHh3nq2LkYuDiGBRYwSq288Z4RwXjNKHDh/lgWkildAQ2Lr4YVsIDaL
	gKrEm4UQcTYBLYn9L26AxUUFwiRWTr8CVS8o8WPyPTBbRMBQ4uDu7UwgQ5kFljNJPHw1jxkk
	ISwQItHd/hFqdSujxLztF8Bu4hTwkHj74w87iM0soCOxv3UaG4QtL7F5zVvmCYwCs5AsmYWk
	bBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP6mfQOxlUNFocYBTgYlXh4Hdjc
	Q4RYE8uKK3MPMUpwMCuJ8N5LBwrxpiRWVqUW5ccXleakFh9iNAWGwURmKdHkfGC6ySuJNzQ2
	MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwKidmfY/v1ROtPbV9osFpdd+
	O6xYfn1Oxor7xm/i+RrPTjAtnL7dmldbQf6/R2RDTAtjwusw7+e//35elHtsw1or8V1eM9iT
	jU9mrH754/E/nictJqLcenk6fbfkDnXuPtxrmeXVHe0SsWT9xQWzp8RUzji5qCdi3Yq425mH
	//f/Fat+cLfq0TUlluKMREMt5qLiRAB6u8Tg/wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

The extcon-max77693.c was tested by all cables (mhl, hdmi, usb, usb-host, dock for audio play, dock for mhl).
with default_init_data register setting. If you deletes legacy default_init_data[] register setting,
extcon-max77693.c can not guarantee the operation of upper cables.

So, I want to maintain 'default_init_data' register setting value.

Thanks,
Chanwoo Choi

On 10/22/2014 05:45 PM, Krzysztof Kozlowski wrote:
> The driver was requesting all MUIC interrupts but then was masking most
> of them manually at end of probe (with default_init_data). Since
> default_init_data cannot be passed through DTS (no bindings for driver),
> this was a conflicting behavior. First get everything, then mask what we
> don't want.
> 
> This could change after adding DTS bindings for requesting specific
> MUIC interrupts. Until then driver should request only these MUIC
> interrupts which he is really interested in.
> 
> The commit does not introduce any functional change when the driver is
> used with DTS (no platform data). However this changes the behavior with
> platform data supplied. In such case the driver will request only 3
> interrupts (ADC, ADC1K, ChgTyp). Platform data could still unmask other
> interrupts but they won't be handled by the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c | 26 --------------------------
>  1 file changed, 26 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 863d088c9bdd..9d21e75a7032 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -44,19 +44,6 @@ static struct max77693_reg_data default_init_data[] = {
>  		.addr = MAX77693_MUIC_REG_STATUS2,
>  		.data = STATUS2_CHGDETRUN_MASK,
>  	}, {
> -		/* INTMASK1 - Unmask [3]ADC1KM,[0]ADCM */
> -		.addr = MAX77693_MUIC_REG_INTMASK1,
> -		.data = INTMASK1_ADC1K_MASK
> -			| INTMASK1_ADC_MASK,
> -	}, {
> -		/* INTMASK2 - Unmask [0]ChgTypM */
> -		.addr = MAX77693_MUIC_REG_INTMASK2,
> -		.data = INTMASK2_CHGTYP_MASK,
> -	}, {
> -		/* INTMASK3 - Mask all of interrupts */
> -		.addr = MAX77693_MUIC_REG_INTMASK3,
> -		.data = 0x0,
> -	}, {
>  		/* CDETCTRL2 */
>  		.addr = MAX77693_MUIC_REG_CDETCTRL2,
>  		.data = CDETCTRL2_VIDRMEN_MASK
> @@ -135,21 +122,8 @@ struct max77693_muic_irq {
>  
>  static struct max77693_muic_irq muic_irqs[] = {
>  	{ MAX77693_MUIC_IRQ_INT1_ADC,		"muic-ADC" },
> -	{ MAX77693_MUIC_IRQ_INT1_ADC_LOW,	"muic-ADCLOW" },
> -	{ MAX77693_MUIC_IRQ_INT1_ADC_ERR,	"muic-ADCError" },
>  	{ MAX77693_MUIC_IRQ_INT1_ADC1K,		"muic-ADC1K" },
>  	{ MAX77693_MUIC_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
> -	{ MAX77693_MUIC_IRQ_INT2_CHGDETREUN,	"muic-CHGDETREUN" },
> -	{ MAX77693_MUIC_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
> -	{ MAX77693_MUIC_IRQ_INT2_DXOVP,		"muic-DXOVP" },
> -	{ MAX77693_MUIC_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
> -	{ MAX77693_MUIC_IRQ_INT2_VIDRM,		"muic-VIDRM" },
> -	{ MAX77693_MUIC_IRQ_INT3_EOC,		"muic-EOC" },
> -	{ MAX77693_MUIC_IRQ_INT3_CGMBC,		"muic-CGMBC" },
> -	{ MAX77693_MUIC_IRQ_INT3_OVP,		"muic-OVP" },
> -	{ MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,	"muic-MBCCHG_ERR" },
> -	{ MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,	"muic-CHG_ENABLED" },
> -	{ MAX77693_MUIC_IRQ_INT3_BAT_DET,	"muic-BAT_DET" },
>  };
>  
>  /* Define supported accessory type */
> 

