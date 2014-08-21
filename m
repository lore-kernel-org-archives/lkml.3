Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaHUCTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:19:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28680 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaHUCS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:18:59 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7fab6d000004d4a-84-53f557102639
Content-transfer-encoding: 8BIT
Message-id: <53F55710.8000702@samsung.com>
Date: Thu, 21 Aug 2014 11:18:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/2] extcon: sm5502: EXTCON_SM5502 should depend on I2C
References: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
 <1408270138-29811-2-git-send-email-geert@linux-m68k.org>
In-reply-to: <1408270138-29811-2-git-send-email-geert@linux-m68k.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkSFcg/GuwQd8fHYupD5+wWTy7tZfJ
	onnxejaLjr9fGC0u75rDZtH48Sa7xe3GFWwO7B6bVnWyeRw63MHosX/uGnaPvi2rGD0+b5IL
	YI3isklJzcksSy3St0vgyth0cRdLwRaBilefl7E2MC7j62Lk4JAQMJE4/Mi7i5ETyBSTuHBv
	PVsXIxeHkMBSRomP/VNYIBImEjuWnWKESCxilHi/bgcbSIJXQFDix+R7LCCDmAXkJY5cygYJ
	MwuoS0yat4gZov41o8TzpbuZIOq1JP6962EGqWcRUJW4cZ8dJMwGFN7/4gbYSFGBMImV06+A
	jRQR0JWY85MJZAyzwHVGiV2Lz7KC1AgLeEtMf7sBrFdIoF5i6uoZYHFOAVeJM5O6wB6QELjE
	LvHu+lxGkASLgIDEt8mHWCAelpXYdIAZ4i9JiYMrbrBMYBSbheSbWQjfzELyzQJG5lWMoqkF
	yQXFSelFRnrFibnFpXnpesn5uZsYgRF3+t+zvh2MNw9YH2JMBto4kVlKNDkfGLF5JfGGxmZG
	FqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxbefV/CXbbtw0
	f837tEpCca9ghZ3cv4gDt/sdirnVW7yjTwt8OjBfLVEjfnHinamd7P7njerreANati2apM8n
	sflp1c13x79072M//ulazbXaXL+eoivFtYcYl/+/f2zFrexXUXplgtsOOOx8cP+wsc1WTS5T
	11N7NtVcu7ws83rzx20Pf726rcRSnJFoqMVcVJwIAN4sn1DOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV2B8K/BBvuXqFpMffiEzeLZrb1M
	Fs2L17NZdPz9wmhxedccNovGjzfZLW43rmBzYPfYtKqTzePQ4Q5Gj/1z17B79G1ZxejxeZNc
	AGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMTRd3sRRsEah49XkZawPj
	Mr4uRk4OCQETiR3LTjFC2GISF+6tZ+ti5OIQEljEKPF+3Q42kASvgKDEj8n3WLoYOTiYBeQl
	jlzKBgkzC6hLTJq3iBmi/jWjxPOlu5kg6rUk/r3rYQapZxFQlbhxnx0kzAYU3v/iBthIUYEw
	iZXTr4CNFBHQlZjzkwlkDLPAdUaJXYvPsoLUCAt4S0x/uwGsV0igXmLq6hlgcU4BV4kzk7rY
	JjAKzEJy3SyE62YhuW4BI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCIfia1g3Flg8Uh
	RgEORiUe3oYFX4KFWBPLiitzDzFKcDArifC6/gIK8aYkVlalFuXHF5XmpBYfYjQF+m0is5Ro
	cj4w2eSVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamDc/HONuPCu
	qqjusAUzfuYIJe1K2RvQnqwsxPBbmct9of+syQwlrFki3cyTZxne+cXl+Oqn+vYLxnsXW+7T
	3XC36sJHrVeOLLs0Hgm3b+TLFT58f0miAVOm0ZTyHM8mnleTd3S25rRPOv84PbT4YdteDr+6
	1P0zNp4vfma9O6z+7KOqO7MuJvApsRRnJBpqMRcVJwIAoojm7v4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert

Thanks for your report. I already sent a patch[1] to fix this build break
and I'll send pull request to includec this patch in 3.17-rc2.

[1] https://lkml.org/lkml/2014/8/13/761

Best Regards,
Chanwoo Choi


On 08/17/2014 07:08 PM, Geert Uytterhoeven wrote:
> EXTCON_SM5502 selects REGMAP_I2C, but if I2C=n:
> 
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_byte_reg_read’:
> drivers/base/regmap/regmap-i2c.c:28: error: implicit declaration of function ‘i2c_smbus_read_byte_data’
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_byte_reg_write’:
> drivers/base/regmap/regmap-i2c.c:46: error: implicit declaration of function ‘i2c_smbus_write_byte_data’
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_word_reg_read’:
> drivers/base/regmap/regmap-i2c.c:64: error: implicit declaration of function ‘i2c_smbus_read_word_data’
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_word_reg_write’:
> drivers/base/regmap/regmap-i2c.c:82: error: implicit declaration of function ‘i2c_smbus_write_word_data’
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_i2c_write’:
> drivers/base/regmap/regmap-i2c.c:96: error: implicit declaration of function ‘i2c_master_send’
> drivers/base/regmap/regmap-i2c.c: In function ‘regmap_i2c_gather_write’:
> drivers/base/regmap/regmap-i2c.c:117: error: implicit declaration of function ‘i2c_check_functionality’
> drivers/base/regmap/regmap-i2c.c:130: error: implicit declaration of function ‘i2c_transfer’
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/extcon/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6f2f4727de2c..764f3a113e0a 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -72,6 +72,7 @@ config EXTCON_PALMAS
>  
>  config EXTCON_SM5502
>  	tristate "SM5502 EXTCON support"
> +	depends on I2C
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
> 

