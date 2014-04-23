Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaDWGWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:22:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17244 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaDWGWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:22:46 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-6c-53575c350da8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: yuvaraj.cd@samsung.com, "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Sonny Rao'" <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org, chris@printf.net,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1398210681-22976-1-git-send-email-dianders@chromium.org>
In-reply-to: <1398210681-22976-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: Don't print data errors
Date: Wed, 23 Apr 2014 15:22:44 +0900
Message-id: <000201cf5ebc$70213200$50639600$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ehe+RuOPv4XJqQQuiGIdShOq36wANEp0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zfV3TmPBggwVTuC0ezNvGZjHh8nZG
	i7PLDrJZ3PjVxmpxedccNosj//sZLWac38dk8eTMTEaL42vDLc6eKnfg8pjdcJHF4861PWwe
	N14tZPLo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujNe79rIWnOOu6Po+h6mBcSVnFyMnh4SA
	icSePV9YIWwxiQv31rN1MXJxCAksY5S48/kGM0zRz4N7mCES0xkldnWugar6wyix590JJpAq
	NgEtib9v3gBVcXCICIRL7L2pAlLDLPCFUWLq/ftgk4QEXCV+vv3BCFLDKeAm8XmbNIgpLGAp
	0dFWAlLBIqAqcerdH0YQm1fAVuLn+dVQtqDEj8n3WEBsZgEDifez+lghbHmJzWvegm2VEFCX
	ePRXFyQsImAkse7kAXaIEhGJfS/eMYJcIyHQyCGxdN0+VohdAhLfJh9igeiVldh0AOpdSYmD
	K26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MUKiesIO
	xnsHrA8xJgOtn8gsJZqcD0wKeSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXA6BahXqPsc8Jh0iqN3rUVPZE2q8RjTk29cidz3uNpNjZzG9zWaj/Z
	fc/MOyWtu/Xkhpszn3h4Lz/Ndq2CPXzbwpXLtSc6yO5hPfrc1azAYUfo0U2h3Bdc9zz7KMId
	8/q5mIRh4M83s9SeHqz/feZDrfY6Zb4tVa0LfBZfberkv21y89iV0o1PQpVYijMSDbWYi4oT
	Ae1HcCsAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV3TmPBgg1tL2CwezNvGZjHh8nZG
	i7PLDrJZ3PjVxmpxedccNosj//sZLWac38dk8eTMTEaL42vDLc6eKnfg8pjdcJHF4861PWwe
	N14tZPLo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmv
	d+1lLTjHXdH1fQ5TA+NKzi5GTg4JAROJnwf3MEPYYhIX7q1n62Lk4hASmM4osatzDZTzh1Fi
	z7sTTCBVbAJaEn/fvAHq4OAQEQiX2HtTBaSGWeALo8TU+/fBJgkJuEr8fPuDEaSGU8BN4vM2
	aRBTWMBSoqOtBKSCRUBV4tS7P4wgNq+ArcTP86uhbEGJH5PvsYDYzAIGEu9n9bFC2PISm9e8
	BdsqIaAu8eivLkhYRMBIYt3JA+wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCU8YzqR2MKxssDjEKcDAq8fAWrAwLFmJNLCuuzD3EKMHB
	rCTCO/MjUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgeksryTe0NjEzMjSyMzCyMTcnDRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY1xx3SBTVj/qk6xO7+M8S02vz/F7+OC53Omhu
	TJLA59OK5Tot12bEPr5dIVVRmXo48djWCmPrpAi7N1cy5pZffS04qZhtfvp5yZ6088+3ra47
	kPROmkPtHI/c1VdLqjjLLq7YxNHpfPyS26JIO9ZpC5rXzd/nn8IRaXrSa2Gf6ob5AZq90duK
	lViKMxINtZiLihMB/mM+dl0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, April 23, 2014, Doug Anderson wrote:
> Data errors are completely expected during tuning.  Printing them out
> is confusing people looking at the kernel logs.  They see things like:
> 
>  [    3.613296] dwmmc_exynos 12200000.dwmmc0: data error, status 0x00000088
> 
> ...and they think something is wrong with their hardware.
> 
> Remove the printouts.  We'll leave it up to a higher level to report
> about errors.
Yes, your saying makes sense.
But in normal I/O, actual error information such as status below is useful, isn't it?

Thanks,
Seungwon Jeon

> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index cced599..4c8d423 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1248,7 +1248,7 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>  			data->error = -EIO;
>  		}
> 
> -		dev_err(host->dev, "data error, status 0x%08x\n", status);
> +		dev_dbg(host->dev, "data error, status 0x%08x\n", status);
> 
>  		/*
>  		 * After an error, there may be data lingering
> --
> 1.9.1.423.g4596e3a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

