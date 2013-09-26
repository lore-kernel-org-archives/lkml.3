Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3IZGlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:41:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12450 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3IZGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:41:34 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-b2-5243d71ced18
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Milo Kim'" <milo.kim@ti.com>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <001201ceba5d$8e3f48c0$aabdda40$%han@samsung.com>
In-reply-to: <001201ceba5d$8e3f48c0$aabdda40$%han@samsung.com>
Subject: Re: [PATCH V2 12/18] regulator: max8952: use devm_regulator_register()
Date: Thu, 26 Sep 2013 15:41:32 +0900
Message-id: <002f01ceba83$70017970$50046c50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAQ3kgAAlWMXA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zA12Z685BBv9eyVtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LBYn//QyOrB57Jx1l91j06pONo871/awefRtWcXocfzGdiaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDJ+trxmL2hnr3j9qZulgfEGaxcjJ4eEgInEpG2HmCBsMYkL99az
	dTFycQgJLGOUaJoxix2maN3xA2C2kMAiRonpy2Ig7F+MEr0LGEFsNgE1iS9fDoPViAj4S+y+
	+4QVZBCzQDejxK5VU1kgGgolXi6dwwZicwrYSdxpOwFkc3AIAzVsauYCCbMIqEqsujeVGSTM
	K2Ar8eBKHUiYV0BQ4sfke2BTmAW0JNbvPM4EYctLbF7zFqxcQkBd4tFfXYgLrCRubO6GKhGR
	2PfiHSPINRICL9klXn7vZIVYJSDxbfIhFoheWYlNB5ghvpWUOLjiBssERolZSDbPQrJ5FpLN
	s5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJHL7dzDePWB9iDEZaP1EZinR5Hxg
	5OeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXER
	r2xLlwWPne6mv9v/Z1jvE7ZjO7XmqdeWX9Jd4ksfdn5VvlLBvE03JfHzKc/vh06uyZ5gU+c3
	ZVGGmlxx4I6rx5fELrFYMje3eXrdgaLF657rRCZ/anlT+jv33nyx/Qbn76je77yz9rpX18IF
	i6v8PzZfFwcavr3tXNVqARED+zvTpb9xeimxFGckGmoxFxUnAgDWVWEO8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV2Z685BBic+SFtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LBYn//QyOrB57Jx1l91j06pONo871/awefRtWcXocfzGdiaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/Gx5zV7Qzl7x+lM3SwPj
	DdYuRk4OCQETiXXHD7BD2GISF+6tZwOxhQQWMUpMXxYDYf9ilOhdwAhiswmoSXz5chisXkTA
	X2L33SdAc7g4mAW6GSV2rZrKAtFQKPFy6RywQZwCdhJ32k4A2RwcwkANm5q5QMIsAqoSq+5N
	ZQYJ8wrYSjy4UgcS5hUQlPgx+R7YFGYBLYn1O48zQdjyEpvXvAUrlxBQl3j0VxfiAiuJG5u7
	oUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BKeFZ1I7GFc2WBxiFOBgVOLhvcDsHCTEmlhWXJl7iFGCg1lJhPebEVCINyWxsiq1KD++qDQn
	tfgQYzLQnxOZpUST84EpK68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGHknPlF5FfHm2Y9tV/m2zFm6sI2rc61mfvUjhmkRZkpVz7vUEvY8L/w971HEieQ3
	BxuNVvifO2pkudfty45bvF4nAhw7Zjbc+nnEvXf6PC6e1THV0zhThWXSOc/3Td8dMYU3Q0Wi
	dfsrmS333p49u/jjvKnad6RjPBIfKS2dZaH3RCvYZTv/nTolluKMREMt5qLiRADZ0UxKTwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 11:10 AM, Jingoo Han wrote:
> 
> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/max8952.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

[.....]

> @@ -321,9 +322,6 @@ static int max8952_pmic_remove(struct i2c_client *client)
>  {
>  	struct max8952_data *max8952 = i2c_get_clientdata(client);
>  	struct max8952_platform_data *pdata = max8952->pdata;
> -	struct regulator_dev *rdev = max8952->rdev;
> -
> -	regulator_unregister(rdev);
> 
>  	gpio_free(pdata->gpio_vid0);
>  	gpio_free(pdata->gpio_vid1);

CC'ed Sachin Kamat,

Freeing the gpios before unregistering the device is not right,
even though it does not make the functional problems.
So, I will remove this patch from v3 patch series.

Best regards,
Jingoo Han

