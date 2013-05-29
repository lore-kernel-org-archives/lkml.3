Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab3E2IUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:20:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51493 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057Ab3E2IUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:20:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-83-51a5ba3246fb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Nikolay Balandin'" <n.a.balandin@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Nikolay Balandin'" <nbalandin@dev.rtsoft.ru>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Bill Pemberton'" <wfp5p@virginia.edu>,
        "'Alexandre Pereira da Silva'" <aletes.xgr@gmail.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
References: <1369771281-5527-1-git-send-email-n.a.balandin@gmail.com>
In-reply-to: <1369771281-5527-1-git-send-email-n.a.balandin@gmail.com>
Subject: Re: [PATCH v3 2/2] drivers/misc: at25: convert to use devm_kzalloc
Date: Wed, 29 May 2013 17:20:02 +0900
Message-id: <000801ce5c45$5117dbe0$f34793a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIoYLu5+4HRPP6eFnouTSw7sZ4325hnyO0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI12jXUsDDf7tU7d49mYpq8XLCYcZ
	LZoXr2ezuLzwEqtFx98vjBaXd81hs/iw4Q2Txf+nz9ktVv0/y2Kx8sQsZgcujwXTfjB57Jx1
	l91j/9w17B59W1Yxepw89YTF4/MmOY8Xx18yBbBHcdmkpOZklqUW6dslcGXc7zvEXNAkWrH0
	/grWBsa5Al2MnBwSAiYSOx8cZoGwxSQu3FvP1sXIxSEksIxR4sDiiYwwRVv+nYZKTGeUuHtu
	AZTzi1Fi/satzCBVbAJqEl++HGYHsUUEUiT2NXeBFTELHGGSeNzVBJYQEnCV+NJ2jwnE5hRw
	k/j1+Q1YXFjAW+LZ4QagOAcHi4CqxL3ldiBhXgFLiU8/rjND2IISPybfAzuVWUBLYv3O40wQ
	trzE5jVvmSEuVZDYcfY1I8QNRhJXrj6AqhGR2PfiHSPIPRICEzkktt/YCzaIRUBA4tvkQywg
	eyUEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFp
	Xrpecn7uJkZIzPfvYLx7wPoQYzLQ+onMUqLJ+cCUkVcSb2hsZmRhamJqbGRuaUaasJI4r1qL
	daCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxt0B2X8/fcnYtvY8Y+YJma+tgZ5XV8Qvt2ua
	aFt9Sers5q0an3nSj5doHzogqLRgX3vCIYmyH3UuPR627+x5FKRYssO0z/0XP+SWbVN5c6p2
	B7NQ1tqvwbsWskmKrHt48fNsre2HbzdIv03oPh0remjaGpE/X7fcXRjeala2OXvdkc9Ce9pW
	ayixFGckGmoxFxUnAgCJFW8RDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQV2jXUsDDVouKVk8e7OU1eLlhMOM
	Fs2L17NZXF54idWi4+8XRovLu+awWXzY8IbJ4v/T5+wWq/6fZbFYeWIWswOXx4JpP5g8ds66
	y+6xf+4ado++LasYPU6eesLi8XmTnMeL4y+ZAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AOVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFm3O87xFzQJFqx9P4K1gbGuQJdjJwcEgImElv+nWaDsMUkLtxbD2RzcQgJ
	TGeUuHtuAZTzi1Fi/satzCBVbAJqEl++HGYHsUUEUiT2NXeBFTELHGGSeNzVBJYQEnCV+NJ2
	jwnE5hRwk/j1+Q1YXFjAW+LZ4QagOAcHi4CqxL3ldiBhXgFLiU8/rjND2IISPybfYwGxmQW0
	JNbvPM4EYctLbF7zlhniUgWJHWdfM0LcYCRx5eoDqBoRiX0v3jFOYBSahWTULCSjZiEZNQtJ
	ywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQnlmfQOxlUNFocYBTgYlXh4A74uCRRi
	TSwrrsw9xCjBwawkwpsquDRQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OByS6vJN7Q2MTM
	yNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhi9pwXeN72R/+aqPO+E1XNO
	2+4sTPkvJ8f0KUJQ+t219WwXrbpDZut2rFg78blbg3fz8nmPH+0JtlOrjF4zYffL553trwP1
	JFwPeMnLN17I47OO446d6fbevO3WurcusaZfoi4keVZl7S8Jr/3zUZN9c1ACd8DGcBOD5zzz
	OCRlF/3+y3fHLF2JpTgj0VCLuag4EQAVVzKjbAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 5:01 AM, Nikolay Balandin wrote:
> 
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
> 
> Use devm_kzalloc to make cleanup paths simpler
> 
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


> ---
>  drivers/misc/eeprom/at25.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index ad8fd8e..840b359 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -371,11 +371,10 @@ static int at25_probe(struct spi_device *spi)
>  		if (np) {
>  			err = at25_np_to_chip(&spi->dev, np, &chip);
>  			if (err)
> -				goto fail;
> +				return err;
>  		} else {
>  			dev_err(&spi->dev, "Error: no chip description\n");
> -			err = -ENODEV;
> -			goto fail;
> +			return -ENODEV;
>  		}
>  	} else
>  		chip = *(struct spi_eeprom *)spi->dev.platform_data;
> @@ -389,8 +388,7 @@ static int at25_probe(struct spi_device *spi)
>  		addrlen = 3;
>  	else {
>  		dev_dbg(&spi->dev, "unsupported address type\n");
> -		err = -EINVAL;
> -		goto fail;
> +		return -EINVAL;
>  	}
> 
>  	/* Ping the chip ... the status register is pretty portable,
> @@ -400,14 +398,12 @@ static int at25_probe(struct spi_device *spi)
>  	sr = spi_w8r8(spi, AT25_RDSR);
>  	if (sr < 0 || sr & AT25_SR_nRDY) {
>  		dev_dbg(&spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
> -		err = -ENXIO;
> -		goto fail;
> +		return -ENXIO;
>  	}
> 
> -	if (!(at25 = kzalloc(sizeof *at25, GFP_KERNEL))) {
> -		err = -ENOMEM;
> -		goto fail;
> -	}
> +	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
> +	if (!at25)
> +		return -ENOMEM;
> 
>  	mutex_init(&at25->lock);
>  	at25->chip = chip;
> @@ -439,7 +435,7 @@ static int at25_probe(struct spi_device *spi)
> 
>  	err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
>  	if (err)
> -		goto fail;
> +		return err;
> 
>  	if (chip.setup)
>  		chip.setup(&at25->mem, chip.context);
> @@ -453,10 +449,6 @@ static int at25_probe(struct spi_device *spi)
>  		(chip.flags & EE_READONLY) ? " (readonly)" : "",
>  		at25->chip.page_size);
>  	return 0;
> -fail:
> -	dev_dbg(&spi->dev, "probe err %d\n", err);
> -	kfree(at25);
> -	return err;
>  }
> 
>  static int at25_remove(struct spi_device *spi)
> @@ -465,7 +457,6 @@ static int at25_remove(struct spi_device *spi)
> 
>  	at25 = spi_get_drvdata(spi);
>  	sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
> -	kfree(at25);
>  	return 0;
>  }
> 
> --
> 1.7.9.5

