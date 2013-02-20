Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910Ab3BTKqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:46:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11889 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab3BTKqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:46:32 -0500
X-AuditID: cbfee691-b7f556d000001a24-c1-5124a98752c3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
References: <000101ce0e3d$9a9e42a0$cfdac7e0$%han@samsung.com>
In-reply-to: <000101ce0e3d$9a9e42a0$cfdac7e0$%han@samsung.com>
Subject: Re: [PATCH] mfd: twl4030-madc: add __exit macro to remove
Date: Wed, 20 Feb 2013 19:46:31 +0900
Message-id: <000001ce0f57$8b237050$a16a50f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OPZqJHNio5XJvR8u8Q36MxoUVqwBGaVng
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA932lSqBBp82SFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MV9/fMhf0s1fMWKTVwPictYuRk0NCwERi7fkGFghbTOLCvfVs
	XYxcHEICyxglTm2+yg5TtOjDSmaIxCJGiSNNe9ghnNlMErta2xhBqtgE1CS+fDkM1iEi4Cdx
	oPcjmM0soCDx694msHVCArYSk2ZdAFvHKWAn8efGNTBbWMBJYlf7djCbRUBVYsXBbiYQmxeo
	vu3ueXYIW1Dix+R7LBAztSTW7zzOBGHLS2xe8xboOg6gS9UlHv3VhTjBSOJn+wxmiBIRiX0v
	3jFCPDOPXWJWpzjEKgGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICR
	ZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSFxN3MF4/4D1IcZkoPUTmaVEk/OBcZlXEm9o
	bGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw7dzUWrrO/
	0H5cvSh69e5bMsL/5y62ie6fwmMqYZ55ze19lSrTkc2Bvif0X8x+aB646gnXSz/ToCo1Hv/0
	R0dnLy6/te2ji9Pzc5x/Rew2sb154NAjJKkhNvdIxBOG/SdKXjd0nnI22cd450IWy7UMwwvC
	7L/urQ7dxBUwzXlRlp67Se261V5KLMUZiYZazEXFiQB+RICwwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG77SpVAg95VwhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49X3t8wF/ewVMxZpNTA+
	Z+1i5OSQEDCRWPRhJTOELSZx4d56ti5GLg4hgUWMEkea9rBDOLOZJHa1tjGCVLEJqEl8+XKY
	HcQWEfCTOND7EcxmFlCQ+HVvE9hUIQFbiUmzLrCA2JwCdhJ/blwDs4UFnCR2tW8Hs1kEVCVW
	HOxmArF5gerb7p5nh7AFJX5MvscCMVNLYv3O40wQtrzE5jVvgS7lALpUXeLRX12IE4wkfrbP
	YIYoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREct8+kdjCubLA4xCjAwajEw6sxXzlQiDWxrLgy9xCjBAezkgjvzw6VQCHelMTKqtSi/Pii
	0pzU4kOMyUCPTmSWEk3OB6aUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1I
	LYLZwsTBKdXAuCswZs9ungtvLoYLXfR3UJBv1G46+7GWd9Zbp4KzT+/osvSsmZ8gekQr1fbQ
	pMtpR2U1/t4qDTIQUYvmv3tKd2nl8uM8fAdn5H37zy75qPSHO6Ow17IZXwuvMTU77tVjEexr
	vLU1ID+NMyuwb8lS3xufTuf9+2jrfWBd36fV5V/nOFr6rD26WImlOCPRUIu5qDgRAHcrisAf	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 19, 2013 10:08 AM, Jingoo Han wrote:
> 
> Fixed build warning as below:
> 
> drivers/mfd/twl4030-madc.c:788:12: warning: 'twl4030_madc_remove' defined but not used [-Wunused-
> function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/twl4030-madc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 88ff9dc..86ba920 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c
> @@ -785,7 +785,7 @@ err_power:
>  	return ret;
>  }
> 
> -static int twl4030_madc_remove(struct platform_device *pdev)
> +static int __exit twl4030_madc_remove(struct platform_device *pdev)
>  {
>  	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);

Removing __exit_p() would be better.
I will send V2 patch.

> 
> --
> 1.7.2.5


