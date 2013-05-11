Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3EKFh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:37:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27324 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3EKFhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:37:24 -0400
X-AuditID: cbfee68d-b7f016d000007930-ac-518dd913f1e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-34-git-send-email-wsa@the-dreams.de>
In-reply-to: <1368173847-5661-34-git-send-email-wsa@the-dreams.de>
Subject: Re: [RFC 33/42] drivers/video/omap2: don't check resource with
 devm_ioremap_resource
Date: Sat, 11 May 2013 14:37:22 +0900
Message-id: <002e01ce4e09$9c849590$d58dc0b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKrVsRnZVwbWOaUrA6bMaaf4JBF+gF1U0MHlzm66yA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zQ13hm72BBr8msFl0zrzGaHGi7wOr
	xeVdc9gsZi/pZ7FYP/8Wm8XKE7OYHdg8PnyM8zh56gmLx/Eb25k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mr4vOs0a8FjzoqLCx8xNjB+Ze9i5OSQEDCR+PFyETOELSZx4d56ti5GLg4hgWWMErea
	jjHBFM3f18wCkVjEKPFw63Soql+MEmu6nzGCVLEJqEl8+XIYbKyIgIvExv+3wIqYBRYySqxc
	tAmsSEigQuLDtKUsIDangJPExttbwRqEBeIlXn27xgZiswioSlyZswmshlfAUuLbnh5GCFtQ
	4sfke2BxZgEtifU7jzNB2PISm9e8hfpBQWLH2deMEEdYSaxc8ZsZokZEYt+Ld4wgB0kI3GKX
	eHX/NgvEMgGJb5MPAdkcQAlZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpa
	kFxQnJReZKhXnJhbXJqXrpecn7uJERKtvTsYbx+wPsSYDLR+IrOUaHI+MNrzSuINjc2MLExN
	TI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBY6bzqtGzinElanX8s
	GxLE18c/vr3u1KTVzzfsyVndNnOqtbJc+QPD+m1FioZzdc7zn3xwWdvuT1HbkzPRe74pfH1r
	2edn0PE4TFoh5qd8E89h8S9ai6fwfP46k6k2Zv6Dv6ddWPZPLjVr/HZke5mNd3kTV3HMxNCz
	4fJHJnVcvhxyast0YculSizFGYmGWsxFxYkA8oYYZOwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3hm72BBpemMFl0zrzGaHGi7wOr
	xeVdc9gsZi/pZ7FYP/8Wm8XKE7OYHdg8PnyM8zh56gmLx/Eb25k8Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+LzrNGvBY86KiwsfMTYwfmXvYuTkkBAwkZi/
	r5kFwhaTuHBvPVsXIxeHkMAiRomHW6dDOb8YJdZ0P2MEqWITUJP48uUwWLeIgIvExv+3wIqY
	BRYySqxctAmsSEigQuLDtKVgYzkFnCQ23t4K1iAsEC/x6ts1NhCbRUBV4sqcTWA1vAKWEt/2
	9DBC2IISPybfA4szC2hJrN95nAnClpfYvOYtM8SpChI7zr5mhDjCSmLlit/MEDUiEvtevGOc
	wCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPBM+kdjKsa
	LA4xCnAwKvHwVgj1BgqxJpYVV+YeYpTgYFYS4T0yHSjEm5JYWZValB9fVJqTWnyIMRno04nM
	UqLJ+cA0lVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjPGx
	17T899u4X/61Lm3T3vlMB6uS38vxHq4vPNDhfjDxnXzw2gsP/q34Z1JdKHn1tsAd5rvvw5Xb
	dbIixd57/Z+zevW7wt/LVnzTfXTDYtpd3WsNsn/kc22vybFwbyxOvGd4x97h/a7fSoqPXz9e
	dlKncaa+bNK3isomv9S7dlpPNqjfObPteboSS3FGoqEWc1FxIgCfBJ1MSQMAAA==
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

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/omap2/vrfb.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/video/omap2/vrfb.c b/drivers/video/omap2/vrfb.c
> index 5261229..f346b02 100644
> --- a/drivers/video/omap2/vrfb.c
> +++ b/drivers/video/omap2/vrfb.c
> @@ -353,11 +353,6 @@ static int __init vrfb_probe(struct platform_device *pdev)
>  	/* first resource is the register res, the rest are vrfb contexts */
> 
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "can't get vrfb base address\n");
> -		return -EINVAL;
> -	}
> -
>  	vrfb_base = devm_ioremap_resource(&pdev->dev, mem);
>  	if (IS_ERR(vrfb_base))
>  		return PTR_ERR(vrfb_base);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

