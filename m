Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbaH0ENQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:13:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17355 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaH0ENO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:13:14 -0400
X-AuditID: cbfee690-f79ce6d00000115a-19-53fd5ad8d1e0
Message-id: <53FD5AD7.1010402@samsung.com>
Date: Wed, 27 Aug 2014 13:13:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, olof@lixom.net,
        Sonny Rao <sonnyrao@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <cjb@laptop.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: dw_mmc: Pass back errors from mmc_of_parse()
References: <1408990744-1093-1-git-send-email-dianders@chromium.org>
In-reply-to: <1408990744-1093-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkSPdG1N9gg++TJS2W/f/OZDHh8nZG
	i+2vN7JZnF12kM3ixq82VovLu+awWRz5389ocer6ZzaLJ2dmMlp8uH+R2eL42nCLh0e7WR14
	PGY3XGTx2DnrLrvHoStrGT3uXNvD5nHlRBOrx41XC5k8/s7az+LRt2UVo8fnTXIBnFFcNimp
	OZllqUX6dglcGfNmrWYpOM5TcepXL3MDYz9XFyMHh4SAicTBpeFdjJxAppjEhXvr2UBsIYGl
	jBKbd0tCxE0k3vQ2MXYxcgHFpzNKPDqzihnCec0osWTqYSaQQbwCWhKf/0iBNLAIqEo833qX
	HcRmE9CR2P7tOBOILSoQJnGobR6YzSsgKPFj8j0WEFtEwF/iW/9UVpCZzAL7mST+vpoN1iws
	4Cbx6+YTVoiLXCRm3D4K1sAp4Cqx7tEiRhCbGWjB/tZpbBC2vMTmNW/BjpMQmMoh8eP5U0aI
	iwQkvk0+xALxsazEpgPMEJ9JShxccYNlAqPYLCQ3zUIydhaSsQsYmVcxiqYWJBcUJ6UXmegV
	J+YWl+al6yXn525iBEbz6X/PJuxgvHfA+hCjAAejEg/vhwV/goVYE8uKK3MPMZoCXTGRWUo0
	OR+YMvJK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCY
	ednWcs2m9VUnNrvPsGjzPR9l/GjabOtf606uFF7ve96SWc7re3v5VRl7981bGJhczl0tmaq9
	PXVRC7fFthcW/81eVu+NyeTirxLPyArcH+qktOTltq9dMstKdp+snKZgbHIzpdFm9d0HmXvd
	Vx0//0stMOZm9r7N9pwqq4QPafN9nLwq8by1EktxRqKhFnNRcSIA3hoEN+ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd0bUX+DDXrWCVos+/+dyWLC5e2M
	Fttfb2SzOLvsIJvFjV9trBaXd81hszjyv5/R4tT1z2wWT87MZLT4cP8is8XxteEWD492szrw
	eMxuuMjisXPWXXaPQ1fWMnrcubaHzePKiSZWjxuvFjJ5/J21n8Wjb8sqRo/Pm+QCOKMaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGbMm7WapeA4T8WpX73MDYz9XF2MnBwS
	AiYSb3qbGCFsMYkL99azdTFycQgJTGeUeHRmFTOE85pRYsnUw0xdjBwcvAJaEp//SIE0sAio
	SjzfepcdxGYT0JHY/u04E4gtKhAmcahtHpjNKyAo8WPyPRYQW0TAX+Jb/1RWkJnMAvuZJP6+
	mg3WLCzgJvHr5hNWEFtIwEVixu2jYA2cAq4S6x4tAruOGWjB/tZpbBC2vMTmNW+ZJzAKzEKy
	YxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Xz6R3MK5qsDjEKMDBqMTD
	+2HBn2Ah1sSy4srcQ4wSHMxKIrwl4X+DhXhTEiurUovy44tKc1KLDzGaAoNgIrOUaHI+MJXl
	lcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgFKp+5Fjvu5bjz+26
	k7vVWz6YLGX3EV2wNy9Qq0TWumH3y6yzGeqzT2QHMz/Sm9jGEef95o1Own47l2+LJ2z+y/m1
	9CFPLMu5CW1OpZvst3womi2euXGLwscLczXcN51f+dbhmVRAnaIo076UE99eO0wMTG1ZfHDZ
	mhPJRusl+aMKK2u+hYpvU2Ipzkg01GIuKk4EAHaigX8tAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 08/26/2014 03:19 AM, Doug Anderson wrote:
> It's possible that mmc_of_parse() could return errors (possibly in
> some future version it might return -EPROBE_DEFER even).  Let's pass
> those errors back.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 7f227e9..9ef4df0 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2131,7 +2131,9 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	if (host->pdata->caps2)
>  		mmc->caps2 = host->pdata->caps2;
>  
> -	mmc_of_parse(mmc);
> +	ret = mmc_of_parse(mmc);
> +	if (ret)
> +		goto err_host_allocated;
>  
>  	if (host->pdata->blk_settings) {
>  		mmc->max_segs = host->pdata->blk_settings->max_segs;
> @@ -2163,7 +2165,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  
>  	ret = mmc_add_host(mmc);
>  	if (ret)
> -		goto err_setup_bus;
> +		goto err_host_allocated;
>  
>  #if defined(CONFIG_DEBUG_FS)
>  	dw_mci_init_debugfs(slot);
> @@ -2174,9 +2176,9 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  
>  	return 0;
>  
> -err_setup_bus:
> +err_host_allocated:
>  	mmc_free_host(mmc);
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)
> 

