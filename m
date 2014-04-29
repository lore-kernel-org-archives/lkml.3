Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaD2GHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:07:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8738 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaD2GHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:07:09 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-b4-535f418a3851
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jimmy Li'" <coder.liss@gmail.com>
Cc: "'Jonathan Cameron'" <jic23@kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Monam Agarwal'" <monamagarwal123@gmail.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140429055544.GA23599@gmail.com>
In-reply-to: <20140429055544.GA23599@gmail.com>
Subject: Re: [PATCH] staging:iio:ad2s1210 fix a leak when device removed
Date: Tue, 29 Apr 2014 15:07:04 +0900
Message-id: <001401cf6371$3e98cf90$bbca6eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jb66rjj8ZWOU5Rn+UNP4LK1u3rAAAEGrw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zQ90ux/hgg8fHFS12//3KYrHnzC92
	i+bF69ksLi+8xGrxoGkVk8WSyfNZLeYdecdicXnXHDaL5t8bGC1O/ulldODyuLfvMIvHzll3
	2T02repk87hzbQ+bx/65a9g9lrw5xOrRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGQt7/rMW
	dHJUvF//mLWB8TZbFyMHh4SAicTNlYFdjJxAppjEhXvr2UBsIYFljBJb9qRCxE0k2h5dZexi
	5AKKL2KUuL3oLhuE85tR4sTsD8wgVWwCahJfvhxmB7FFBFQlXvQdA+tgFnjAJHF2xRd2iLF6
	EosebGYBsTkF9CVWbf8CdoWwgIfE3dcWICYLUO+RvcIgFbwCthKNSyezQtiCEj8m3wPrZBbQ
	kli/8zgThC0vsXnNW2aIX9QlHv3VhbjASOLE35nsECUiEvtevAO7RkJgJofElrdHwWayCAhI
	fJt8iAWiV1Zi0wFmiH8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtIr
	TswtLs1L10vOz93ECIn6vh2MNw9YH2JMBlo/kVlKNDkfmDTySuINjc2MLExNTI2NzC3NSBNW
	Eudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj5gvxoAje4PPiah/PzL+vdC8m1ueZ
	wayOrq19vZO3R74KW3ftcuHs+d+47/jFW4b472ZJC9qfmJmz5d/7w+unFx1e1f6jWITvVUnP
	z7xr5/YePBMRyXmZ5/j8K7vazu07Lfzx3aVNO/35HGNNzHMeXOLTEjt0x/rFzK6bFs3vtlyy
	zjs061VTjBJLcUaioRZzUXEiAKBeMyQQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAd1Ox/hgg0W9oha7/35lsdhz5he7
	RfPi9WwWlxdeYrV40LSKyWLJ5PmsFvOOvGOxuLxrDptF8+8NjBYn//QyOnB53Nt3mMVj56y7
	7B6bVnWyedy5tofNY//cNeweS94cYvXo27KK0ePzJrkAjqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBkLe/6zFnRyVLxf/5i1gfE2WxcjJ4eEgIlE26OrjBC2mMSFe+uB
	4lwcQgKLGCVuL7oL5fxmlDgx+wMzSBWbgJrEly+H2UFsEQFViRd9xxhBipgFHjBJnF3xBSwh
	JKAnsejBZhYQm1NAX2LV9i9Akzg4hAU8JO6+tgAxWYB6j+wVBqngFbCVaFw6mRXCFpT4Mfke
	WCezgJbE+p3HmSBseYnNa94yg7RKCKhLPPqrC3GBkcSJvzPZIUpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeVZ1I7GFc2WBxiFOBgVOLh
	NYiKCxZiTSwrrsw9xCjBwawkwptvFR8sxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnAlJdX
	Em9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyX3CKdau/tCZX/
	pLU3M2+JfvubiM4tOmvFuj/O2Dp1ef+NRcKchv9XRHvGMP/fUlO2MHRTWWXRxbtPwuKE7Wfp
	L33psHDvxMvRW3Yadds/0IhVV5tWvWF19bs5M9fq58gvn5vp8HN11eNNLvI9DrtU1y02cORb
	yHNAx2cBq81Ug+IrLk8XZ99XYinOSDTUYi4qTgQADWIdF28DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 2:56 PM, Jimmy Li wrote:
> 
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>
> ---
>  drivers/staging/iio/resolver/ad2s1210.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
> index 7fbaba4..3d6e123 100644
> --- a/drivers/staging/iio/resolver/ad2s1210.c
> +++ b/drivers/staging/iio/resolver/ad2s1210.c
> @@ -716,6 +716,7 @@ static int ad2s1210_remove(struct spi_device *spi)
> 
>  	iio_device_unregister(indio_dev);
>  	ad2s1210_free_gpios(iio_priv(indio_dev));
> +	devm_iio_device_free(&spi->dev, indio_dev);

NAK.

In ad2s1210_probe(),devm_iio_device_alloc() was already used.
So, when ad2s1210_remove() is called, iio_device_free() will
be called automatically. So, the leak never happens.

If you want to know about devm_* functions, please refer 
to the following.

  Documentation/driver-model/devres.txt

Best regards,
Jingoo Han
> 
>  	return 0;
>  }
> --
> 1.7.9.5

