Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3KJXPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 18:15:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56927 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3KJXOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 18:14:53 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-67-5280136bea94
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
In-reply-to: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Samsung SoC clock drivers
Date: Mon, 11 Nov 2013 08:14:51 +0900
Message-id: <002201cede6a$a8a183a0$f9e48ae0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7c8gHBS0FM2Y0xSsSyO9ZneZ8sKABeHWXg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY91s4YYgg+YXWhaXF15itehdcJXN
	4mzTG3aLTY+vsVpc3jWHzWLG+X1MFmuP3GW3eDrhIpvF4TftrBYn//QyWqyf8ZrFYtWuP4wO
	PB47Z91l97hzbQ+bx+Yl9R59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV0bRhClNBH1fFwdVz
	2BoY13J0MXJySAiYSJzbtZYRwhaTuHBvPVsXIxeHkMAyRokVl3+wwhStOtXNDpGYziix6fQa
	JgjnF6PEl38nwKrYBNQkvnw5zA5iiwi4S/QvXAXWwSywjFmi4eIZNpCEkICLRMflyWBFnAKu
	Et0/j7CA2MICnhL31i0Hs1kEVCVW/voENpRXwFZi46ZL7BC2oMSPyffAapgFtCTW7zzOBGHL
	S2xe85a5i5ED6FR1iUd/dSFuMJI4+GAFVImIxL4X7xhB7pEQmMghceL3anaIXQIS3yYfYoHo
	lZXYdIAZ4mNJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS
	9ZLzczcxQiJ+wg7GewesDzEmA62fyCwlmpwPTBh5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDoY1wTqC7x7mdCd3vIV7Ug8+XOBc5lHtMP2U2u
	mJ2z95dQavKXWyydPJF1B2YdXOIg/lknl30rq2pRCEfUSedjHRGqd8zTdCeqzu/3M//A/dRp
	4yTHGGPtW8WshtMWpM6ZZlVhcca663aMo5HyqqfFxzr7SnhapgZsX3u09ejLNc9iPpbGKyix
	FGckGmoxFxUnAgCWGHB3DgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jQd1s4YYgg4svVC0uL7zEatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLNYeuctu8XTCRTaLw2/aWS1O/ulltFg/4zWLxapdfxgd
	eDx2zrrL7nHn2h42j81L6j36tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6D4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGEdY0bThilMBX1cFQdXz2FrYFzL0cXIySEhYCKx6lQ3O4QtJnHh3nq2LkYuDiGB
	6YwSm06vYYJwfjFKfPl3ghWkik1ATeLLl8NgHSIC7hL9C1exgxQxCyxjlmi4eIYNJCEk4CLR
	cXkyWBGngKtE988jLCC2sICnxL11y8FsFgFViZW/PoEN5RWwldi46RI7hC0o8WPyPbAaZgEt
	ifU7jzNB2PISm9e8Ze5i5AA6VV3i0V9diBuMJA4+WAFVIiKx78U7xgmMQrOQTJqFZNIsJJNm
	IWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4nTyT3sG4qsHiEKMAB6MSD+/F43VB
	QqyJZcWVuYcYJTiYlUR4vZkagoR4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jq8kriDY1N
	zIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMa+5X9wwciune5XyZL/Q
	xb9/bko7sCBZ9qaaRWHuyUeHufaZ3XFe1fi9Se+0uNrkJ6s7VAPmW/0U1Ja4WXn9kNrtzH92
	Ldr267n3q/FZvJrM+mN5dPTMxHUVP07U8HnsiY77nKfy9qaqZTfX7NImp7ILZgfuSPQ53chs
	YPyWEN7GZM/cfcBFiaU4I9FQi7moOBEAU7M6fmsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 09, 2013 11:18 AM, Tomasz Figa wrote:
> 
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch adds an entry for Samsung SoC clock drivers located under
> drivers/clk/samsung/ directory, with me taking the maintainer role.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Mike Turquette <mturquette@linaro.org>
> Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

It looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61b8757..df7e1bf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7319,6 +7319,12 @@ L:	linux-media@vger.kernel.org
>  S:	Supported
>  F:	drivers/media/i2c/s5c73m3/*
> 
> +SAMSUNG SOC CLOCK DRIVERS
> +M:	Tomasz Figa <t.figa@samsung.com>
> +S:	Supported
> +L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> +F:	drivers/clk/samsung/
> +
>  SERIAL DRIVERS
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  L:	linux-serial@vger.kernel.org
> --
> 1.8.4.2

