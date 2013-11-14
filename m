Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3KNM35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:29:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28973 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KNM3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:29:55 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-ab-5284c2414a3c
Message-id: <5284C243.7020403@samsung.com>
Date: Thu, 14 Nov 2013 21:29:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] extcon: arizona: Add support for headphone detection
 on wm5110 rev D
References: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384365877-12355-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1384365877-12355-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkRNfxUEuQwdyP+hb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKuLp7OnPBK86KnY2PWBsYT7F3MXJySAiYSDxZvZAZwhaTuHBvPVsXIxeHkMBS
	Ronl21cywRQ9fvIAKrGIUWLjx/1MEM4rRonff+6BVfEKaElM+fQKzGYRUJVYsmEB2Ao2oPj+
	FzfYQGxRgTCJldOvsEDUC0r8mHwPzBYRsJCYsuQWM8hQZoE+RolHLTNZQRLCAvESi3ZuYYfY
	Np9R4tfDN2CTOIEm/VqxDqyIWUBHYn/rNDYIW15i85q3YJMkBI6xSzy+upsN4iQBiW+TDwGt
	4wBKyEpsOgD1tKTEwRU3WCYwis1CctQsJGNnIRm7gJF5FaNoakFyQXFSepGRXnFibnFpXrpe
	cn7uJkZgvJ3+96xvB+PNA9aHGJOBVk5klhJNzgfGa15JvKGxmZGFqYmpsZG5pRlpwkrivIse
	JgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMy/P2vOY7GNui/s4p34701qWeSYqNBtLlvI
	c05xB8s+S3HF8lkmfX/vbjG33l4cLdRubfO/7/yOlwummgUveX9Hl3927rJZOjNmPA1nmnDy
	uVXti3OSe7SNZIwj2xt23bVuWfCjwqbTtkHRPuaB9qTYRilHdYbnYda5EQZpRxfm6vYGihkb
	K7EUZyQaajEXFScCAP7szpTNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV3HQy1BBhOWaFj8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bV3dOZC15xVuxsfMTawHiKvYuRk0NC
	wETi8ZMHbBC2mMSFe+uBbC4OIYFFjBIbP+5ngnBeMUr8/nOPCaSKV0BLYsqnV2A2i4CqxJIN
	C8AmsQHF97+4ATZJVCBMYuX0KywQ9YISPybfA7NFBCwkpiy5xQwylFmgj1HiUctMVpCEsEC8
	xKKdW9ghts1nlPj18A3YJE6gSb9WrAMrYhbQkdjfOo0NwpaX2LzmLfMERoFZSJbMQlI2C0nZ
	AkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0fxMegfjqgaLQ4wCHIxKPLwS25uDhFgT
	y4orcw8xSnAwK4nwtq5tCRLiTUmsrEotyo8vKs1JLT7EmAwMg4nMUqLJ+cBEk1cSb2hsYmZk
	aWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjKuMb9ipBmYeLdLrmLHWfFaX
	2Y0Jy0sUeC9O2HF55sFtqwTd1WewHb17NvCdXdvDRKefRied5U6mTV3/J89KwbX61hLDtStd
	t6m1lun8/fOuapbtzDsKF++Xz3ld3FBan/Njwkrrlc8utx20kPHXzntzcPM6AS59lVo97Urm
	n8/UkvL9RQ0+3FJiKc5INNRiLipOBADK62TXKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 11/14/2013 03:04 AM, Charles Keepax wrote:
> wm5110 rev D is the first chip to use headphone detection IP 2, specify
> such and make a small correction as the impedance value is actually read
> in 0.5 ohm increments now.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index e311c52..d08e342 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -435,6 +435,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  		}
>  
>  		val &= ARIZONA_HP_LVL_B_MASK;
> +		val /= 2;

What is meaning of 2?

>  
>  		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
>  			    &range);
> @@ -1149,6 +1150,16 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  			break;
>  		}
>  		break;
> +	case WM5110:
> +		switch (arizona->rev) {
> +		case 0 ... 2:
> +			break;
> +		default:
> +			info->micd_clamp = true;
> +			info->hpdet_ip = 2;
> +			break;
> +		}
> +		break;
>  	default:
>  		break;
>  	}
> 


