Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3KLAPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:15:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8420 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3KLAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:15:39 -0500
X-AuditID: cbfee68f-b7f836d000001b39-9e-528173215cde
Message-id: <52817321.9040505@samsung.com>
Date: Tue, 12 Nov 2013 09:15:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQFexuDHI4NQDM4t/U26wW9z/epTR
	4vKuOWwWtxtXsFksf/ufzeJ0N6sDm8eda3vYPOadDPR4OfE3m0ffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlHD7wn62gib9i34OX7A2MLTxdjJwcEgImEjtOrGSHsMUkLtxbz9bFyMUhJLCU
	UeLlyhNMMEUbns5jBLGFBBYxSsxaLQlR9IpR4vOan0AdHBy8AloSDz5Wg9SwCKhKXL+5gxXE
	ZgMK739xgw3EFhUIk1g5/QoLiM0rICjxY/I9MFtEwEJiypJbzCAzmQX6GCUetcwEaxYW8JHY
	9+AfC8Sy+YwSzy8dB5vECTTp+cPPYEXMAjoS+1unsUHY8hKb17xlhrj6GLvE8eepEBcJSHyb
	fIgF5FAJAVmJTQegSiQlDq64wTKBUWwWkptmIZk6C8nUBYzMqxhFUwuSC4qT0ouM9YoTc4tL
	89L1kvNzNzECI+30v2f9OxjvHrA+xJgMtHIis5Rocj4wUvNK4g2NzYwsTE1MjY3MLc1IE1YS
	573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OC2Gddilu94yUsV7Fx7PMVbvBcvnnL
	y8u5kgcuXFJnPTVtxqvga6sYtkYf8LtsmnFil+EKHq7nls8DKqZPEl1p4lJisejQo7s7/Nw7
	Onl4N4YXKNv1mf6pnnpQdMGEP2ceTS7lNmJdl8Udu6WwdqKEY0qEoMKWnScybmVJrbyud3dd
	hqGV0wMlluKMREMt5qLiRADclwREygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV3F4sYgg47behb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHH4wH+2gib+in0PXrI3MLbwdDFyckgI
	mEhseDqPEcIWk7hwbz0biC0ksIhRYtZqyS5GLiD7FaPE5zU/gRIcHLwCWhIPPlaD1LAIqEpc
	v7mDFcRmAwrvf3EDrFdUIExi5fQrLCA2r4CgxI/J98BsEQELiSlLbjGDzGQW6GOUeNQyE6xZ
	WMBHYt+DfywQy+YzSjy/dBxsEifQpOcPP4MVMQvoSOxvncYGYctLbF7zlnkCo8AsJEtmISmb
	haRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgSH4mtYNxZYPFIUYBDkYlHt4dXI1B
	QqyJZcWVuYcYJTiYlUR4zXOBQrwpiZVVqUX58UWlOanFhxiTgWEwkVlKNDkfmGTySuINjU3M
	jCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExXvDxf7Um+736SRr/+338
	BK8k3J3jFmGnsf1V374Zc8LYFr/R2OXovlGa7ZoVR/O84O13vu1jvDP36rZLj4R3it1c810h
	XS3xtafsT5nvdle4OjkuzdJ9ueTijjem1TNNWE8k/5uzUfPIwny359a9AmvzmYP9bmmxtWm6
	lG50dDu8bfaK2hvrlFiKMxINtZiLihMBHro3uCgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi CHarles,

On 11/08/2013 10:19 PM, Charles Keepax wrote:
> As a small disclaimer I would personally prefer to not merge this patch.
> I have added it based on previous code review of the other patches in
> this chain.
> 
> arizona_hpdet_do_id currently can only return 0 or -EAGAIN making the
> else if clause handling error codes redundant, this patch removes this
> clause.
> 
> Whilst this clause is not currently hit removing it makes the code
> fragile. It will not be obvious whilst editing arizona_hpdet_do_id that
> you shouldn't add a return value other than 0 or -EAGAIN.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 0d70bf6..2313b1e 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -476,6 +476,9 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  	return val;
>  }
>  
> +/* This function should only return 0 or -EAGAIN, if other return values are
> + * added additional handling should be added in arizona_hpdet_irq.
> + */

As Lee Jones commented, you should modify this comment of arizona_hpdet_do_id() and add
the description of return value. Because arizoa_hpdet_do_id() has different meaning
between -EAGAIN and other minus value.

>  static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  			       bool *mic)
>  {
> @@ -591,8 +594,6 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
>  	ret = arizona_hpdet_do_id(info, &reading, &mic);
>  	if (ret == -EAGAIN)
>  		goto out;
> -	else if (ret < 0)
> -		goto done;
>  
>  	/* Report high impedence cables as line outputs */
>  	if (reading >= 5000)
> 

Thanks,
Chanwoo Choi
