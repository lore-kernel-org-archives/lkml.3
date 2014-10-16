Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaJPCZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:25:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48738 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaJPCZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:25:39 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-45-543f2ca157c8
Message-id: <543F2CA0.3080703@samsung.com>
Date: Thu, 16 Oct 2014 11:25:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] drivers: rtc: fix s3c-rtc initialization failure without
 rtc source clock
References: <1413372446-28541-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1413372446-28541-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkWHehjn2IwfIrIhZLLl5lt+hdcJXN
	4mzTG3aLy7vmsFmsPXKX3WJ/ZwejA5vHnokn2Tz6tqxi9Jg+7yeTx+dNcgEsUVw2Kak5mWWp
	Rfp2CVwZP7pOsRQs4amYedakgXEaVxcjJ4eEgInE8R3PWCBsMYkL99azdTFycQgJLGWUOH2q
	mQmmaMe2n0wQiemMEo9fPGaBcF4zSlyY+o8dpIpXQEti1qUbrCA2i4CqxLZ/EHE2oPj+FzfY
	QGxRgTCJldOvsEDUC0r8mHwPzBYR0JfobrvCCDKUWWAHo0T3r8OMIAlhgQSJbT9fMoPYQgIe
	Esen7AMbxCngKfHt/H+wZcwCOhL7W6exQdjyEpvXvGUGGSQhsI9d4vLrRnaIiwQkvk0+BLSN
	AyghK7HpADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UUmesWJucWleel6
	yfm5mxiBUXb637MJOxjvHbA+xCjAwajEw2vxyjZEiDWxrLgy9xCjKdAVE5mlRJPzgbGcVxJv
	aGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRkaPgJQ/D8I6
	i2L97/05+TEjU/rkhrMWl7r2dm58fG+y+Zajv8+GTn3GL/i4y57ztvwFzds22yO23vrM+PvL
	2jmvJ87fePBtg91p8UPekfoMqrUcbuekfTyEnDUnfdt57a/99PaONCH3J82zV1ScnL9rH+Nt
	+9fMFutvzjn0WOxo4qTdex+2BG9WYinOSDTUYi4qTgQALZr9wq0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2FOvYhBt9P8losuXiV3aJ3wVU2
	i7NNb9gtLu+aw2ax9shddov9nR2MDmweeyaeZPPo27KK0WP6vJ9MHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvzoOsVSsISnYuZZkwbGaVxdjJwcEgImEju2
	/WSCsMUkLtxbz9bFyMUhJDCdUeLxi8csEM5rRokLU/+xg1TxCmhJzLp0gxXEZhFQldj2DyLO
	BhTf/+IGG4gtKhAmsXL6FRaIekGJH5PvgdkiAvoS3W1XGEGGMgvsYJTo/nWYESQhLJAgse3n
	S2YQW0jAQ+L4lH1ggzgFPCW+nf8PtoxZQEdif+s0NghbXmLzmrfMExgFZiHZMQtJ2SwkZQsY
	mVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfwM+kdjKsaLA4xCnAwKvHwchywDRFiTSwr
	rsw9xCjBwawkwjuXyz5EiDclsbIqtSg/vqg0J7X4EKMpMAgmMkuJJucD00teSbyhsYmZkaWR
	uaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG2MDrdyW2xsRV/29ZE3LljhjX6aSM
	fZG7dHtrbq1r5E3ge3X0/yMTde89ZjxXfnOFbp7/V6H1SIqrWtKurDTZjqfZn3cJhm9dpz/7
	qJ+A46PNx9eZuOeysHYdd/V79H2F3aS2+mQPBbf7eesjrjJUtRdH739nzfzki0HCZSvjw8Jt
	qQeEIh2VWIozEg21mIuKEwGytLdt9wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 08:27 PM, Marek Szyprowski wrote:
> This patch fixes unconditional initialization failure on non-exynos3250
> SoCs. Commit df9e26d093d33a097c5558aab017dd2f540ccfe5 ("rtc: s3c: add support for RTC of Exynos3250 SoC") introduced rtc source clock support,
> but also added initialization failure on SoCs, which doesn't need such
> clock.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/rtc/rtc-s3c.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index a6b1252c9941..806072238c00 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -535,13 +535,15 @@ static int s3c_rtc_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(info->rtc_clk);
>  
> -	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
> -	if (IS_ERR(info->rtc_src_clk)) {
> -		dev_err(&pdev->dev, "failed to find rtc source clock\n");
> -		return PTR_ERR(info->rtc_src_clk);
> +	if (info->data->needs_src_clk) {
> +		info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
> +		if (IS_ERR(info->rtc_src_clk)) {
> +			dev_err(&pdev->dev,
> +				"failed to find rtc source clock\n");
> +			return PTR_ERR(info->rtc_src_clk);
> +		}
> +		clk_prepare_enable(info->rtc_src_clk);
>  	}
> -	clk_prepare_enable(info->rtc_src_clk);
> -
>  
>  	/* check to see if everything is setup correctly */
>  	if (info->data->enable)
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

