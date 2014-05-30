Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaE3B1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:27:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaE3B1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:27:37 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-10-5387de878126
Message-id: <5387DE87.5090009@samsung.com>
Date: Fri, 30 May 2014 10:27:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] extcon: arizona: Update manual headphone detection
 calculation
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401377274-10249-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401377274-10249-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkSLf9XnuwwcyXNhb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGW0nVzEXjBbsGJr
	t3wD4wreLkZODgkBE4ktU+ewQthiEhfurWfrYuTiEBJYyiixbNMNFpii581djCC2kMB0RokX
	EwIhil4zSix91cMGkuAV0JK49rubGcRmEVCVeP7wPVgDG1B8/4sbYDWiAmESK6dfYYGoF5T4
	MfkemC0iYCExZcktsF5mgUSJOee+sHcxcnAIC0RKfF6QDrFrPqNE0+1+sBpOoDm7HxxlgajX
	kdjfOo0NwpaX2LzmLTNIg4TAMnaJ9wdWsEAcJCDxbfIhFpChEgKyEpsOMEM8JilxcMUNlgmM
	YrOQnDQLydhZSMYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREYQ6f/PevbwXjzgPUh
	xmSglROZpUST84ExmFcSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGBnaMrccupYypU+ho0yllDWsYd2GxUH5xxQXJE234XmxQOP166daCSv2dnjf
	WvrvlrHE9KCvN8wc3r20Ya45eepQ2RTXta5/70yedV6ZbcH1Pa5qXbGHrM4nB356tufOukaF
	/uoko+KpCTeec2/ycPz6KKxWOVxPruqYrNCU7OfxXtXsFTaFk5VYijMSDbWYi4oTAeI3/Me3	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG77vfZgg7vLTC3+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMaDu5iL1gtmDF1m75BsYVvF2MnBwSAiYSz5u7GCFsMYkL99azgdhCAtMZ
	JV5MCOxi5AKyXzNKLH3VA5bgFdCSuPa7mxnEZhFQlXj+8D1YMxtQfP+LG2A1ogJhEiunX2GB
	qBeU+DH5HpgtImAhMWXJLbBeZoFEiTnnvrB3MXJwCAtESnxekA6xaz6jRNPtfrAaTqA5ux8c
	ZYGo15HY3zqNDcKWl9i85i3zBEaBWUhWzEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwRH6THoH46oGi0OMAhyMSjy8E9Lbg4VYE8uKK3MPMUpwMCuJ8DoeBgrxpiRWVqUW
	5ccXleakFh9iTAaGwERmKdHkfGDyyCuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGxrw0l787pKbYRWW51DwRiX524bZFxa9AL6k2YcGcDd+3vbjIcSFRf/bS
	P7alyy1+/mf9ol+2NGde448tkyZ8z3ofZrB13m2pvr/JLOd5NmhM/dXwZRPD+pPmD3lrXiz8
	uFB3yYEs1k7Xc4t2XfRYIMHdbLBLTW91zY/eAv/S8H0uIYnzT9rmTVZiKc5INNRiLipOBADG
	zPi9FAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 05/30/2014 12:27 AM, Charles Keepax wrote:
> The higher levels of impedance have a higher minimum value than the
> first level. As the same value was used for all levels, higher impedances
> were reported with a very low level of accuracy. This patch applies the
> approriate lower threshold for each level.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index f2c36b1..c1c8647 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -329,12 +329,13 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
>  }
>  
>  static struct {
> +	unsigned int threshold;
>  	unsigned int factor_a;
>  	unsigned int factor_b;
>  } arizona_hpdet_b_ranges[] = {
> -	{  5528,   362464 },
> -	{ 11084,  6186851 },
> -	{ 11065, 65460395 },
> +	{ 100,  5528,   362464 },
> +	{ 169, 11084,  6186851 },
> +	{ 169, 11065, 65460395 },

If you possible, I want to know the 'unit' of the variable(factor_a, factor_b).

>  };
>  
>  static struct {
> @@ -391,7 +392,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
>  
>  		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
> -		    (val < 100 || val >= 0x3fb)) {
> +		    (val < arizona_hpdet_b_ranges[range].threshold ||
> +		     val >= 0x3fb)) {

I don't understand the meaning of 0x3fb hex value.
I prefer to define constant variable for readability.

>  			range++;
>  			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
>  				range);
> @@ -404,7 +406,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  		}
>  
>  		/* If we go out of range report top of range */
> -		if (val < 100 || val >= 0x3fb) {
> +		if (val < arizona_hpdet_b_ranges[range].threshold ||
> +		    val >= 0x3fb) {

ditto.

>  			dev_dbg(arizona->dev, "Measurement out of range\n");
>  			return ARIZONA_HPDET_MAX;
>  		}
> 

Thanks,
Chanwoo Choi

