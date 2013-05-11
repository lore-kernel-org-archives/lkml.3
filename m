Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3EKFgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:36:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63617 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3EKFgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:36:02 -0400
X-AuditID: cbfee690-b7f136d000000fea-91-518dd8c1839c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-35-git-send-email-wsa@the-dreams.de>
In-reply-to: <1368173847-5661-35-git-send-email-wsa@the-dreams.de>
Subject: Re: [RFC 34/42] drivers/video/omap2/dss: don't check resource with
 devm_ioremap_resource
Date: Sat, 11 May 2013 14:36:01 +0900
Message-id: <002d01ce4e09$6c296f10$447c4d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKrVsRnZVwbWOaUrA6bMaaf4JBF+gK0RS0gly/CxFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ92DN3oDDa4stbHonHmN0eJE3wdW
	i8u75rBZzF7Sz2Kxfv4tNouVJ2YxO7B5fPgY53Hy1BMWj+M3tjN5fN4kF8ASxWWTkpqTWZZa
	pG+XwJVx8OAy9oK53BU9uy+wNTAu5Oxi5OSQEDCReLJtHguELSZx4d56ti5GLg4hgWWMEl9n
	vmCDKfr0ax8LRGI6o8SVJecZIZxfjBKNfRfBqtgE1CS+fDnMDmKLCLhIbPx/C2wUs8BCRomV
	izYxgiSEBCokvrQ2g9mcAk4S61aeZQaxhQWSJb5MfQZ2B4uAqsT/FVuAmjk4eAUsJaYdjwcJ
	8woISvyYfA+shFlAS2L9zuNMELa8xOY1b5khLlWQ2HH2NSPEDVYSvf3PGCFqRCT2vXgHdrSE
	wD12iSnP/kHtEpD4NvkQC8guCQFZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnF
	KJpakFxQnJReZKJXnJhbXJqXrpecn7uJERKrE3Yw3jtgfYgxGWj9RGYp0eR8YKznlcQbGpsZ
	WZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxWrMtQ3HmZLnK
	aHUNtoUFmiJ+JVmV0vLCTge/NAj+KF/AXZZ8Z8/2i5eztxV1XHyt4HSV+04oV2ZtFcOHR16r
	Hl6WPR46UfDi8uu2Gy3Vd1/79SZqjbYl18MlB6Mc2gp8XBiqvhaL9/l07GpMXu0yg/Fo1ZFn
	riu3vGJfVm1QOXmnyKwz+fJKLMUZiYZazEXFiQDpNU9M6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2DN3oDDQ7OtrDonHmN0eJE3wdW
	i8u75rBZzF7Sz2Kxfv4tNouVJ2YxO7B5fPgY53Hy1BMWj+M3tjN5fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfDgMvaCudwVPbsvsDUwLuTsYuTkkBAwkfj0
	ax8LhC0mceHeerYuRi4OIYHpjBJXlpxnhHB+MUo09l1kA6liE1CT+PLlMDuILSLgIrHx/y2w
	DmaBhYwSKxdtYgRJCAlUSHxpbQazOQWcJNatPMsMYgsLJEt8mfoMbB2LgKrE/xVbgJo5OHgF
	LCWmHY8HCfMKCEr8mHwPrIRZQEti/c7jTBC2vMTmNW+ZIS5VkNhx9jUjxA1WEr39zxghakQk
	9r14xziBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ4Jn
	UjsYVzZYHGIU4GBU4uFVEOgNFGJNLCuuzD3EKMHBrCTCe2Q6UIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgUkqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoYT5w6PiO/Q5bd4MdO9scSgSd3FsxedKC0ylzZsD6r+pm/i/PXnH18LKpfbwQ+3Fjru27+
	IgOJG8EnfrU3Pdky32LneuOEnamsq1ests48PYl54sRP51QWfJrZ9v/HxHXzw6wyXNV+7qzc
	kJUjylx+4oqv5HyZD3N87f76K17Svh95edc+vRK+PCWW4oxEQy3mouJEAFah74hIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 5:17 PM, Wolfram Sang wrote:
> 
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/omap2/dss/hdmi.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/video/omap2/dss/hdmi.c b/drivers/video/omap2/dss/hdmi.c
> index 17f4d55..7bc6762 100644
> --- a/drivers/video/omap2/dss/hdmi.c
> +++ b/drivers/video/omap2/dss/hdmi.c
> @@ -1064,13 +1064,8 @@ static int omapdss_hdmihw_probe(struct platform_device *pdev)
>  	mutex_init(&hdmi.lock);
>  	mutex_init(&hdmi.ip_data.lock);
> 
> -	res = platform_get_resource(hdmi.pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		DSSERR("can't get IORESOURCE_MEM HDMI\n");
> -		return -EINVAL;
> -	}
> -
>  	/* Base address taken from platform */
> +	res = platform_get_resource(hdmi.pdev, IORESOURCE_MEM, 0);
>  	hdmi.ip_data.base_wp = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(hdmi.ip_data.base_wp))
>  		return PTR_ERR(hdmi.ip_data.base_wp);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

