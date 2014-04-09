Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaDIFBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:01:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44814 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaDIFBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:01:52 -0400
X-AuditID: cbfee68f-b7f156d00000276c-d9-5344d43f7c3d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1397016042-4451-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1397016042-4451-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/2] usb: ehci-exynos: Return immediately from suspend if
 ehci_suspend fails
Date: Wed, 09 Apr 2014 14:01:50 +0900
Message-id: <000601cf53b0$d17e2b50$747a81f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9TqFFD7OGXF1hpR/Srxh7blnOD5gAB9ZKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA137Ky7BBtePi1q0XTnIbtG8eD2b
	xeWFl1gtehdcZbPY9Pgaq8XlXXPYLGac38dksWhZK7PFhN8X2Bw4PfbPXcPusXlJvcfsuz8Y
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSuj7+N+9oJunopV3y+wNjA+5uxi5OCQEDCRaPtU
	0cXICWSKSVy4t54NxBYSWMYo0dgpChE3kVjzvpW5i5ELKL6IUWLK45mMEM5vRomOk5/BOtgE
	1CS+fDnMDmKLCERK7Ll7kB2kiFngIaPE9cer2SHGuktsaFzMBGJzCnhInN32gxHEFhZIktg2
	6S8ziM0ioCrxY0ovmM0rYCtxcM5VFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jJDfKMu8eiv
	LsQNRhJ7pt1hhigRkdj34h3Y0RICP9kl/lzbzAixS0Di2+RDLBC9shKbDjBDfCwpcXDFDZYJ
	jBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGSDz372C8e8D6
	EGMy0PqJzFKiyfnAdJBXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhhX8Llce6Yquo07yD/k11eHzY6hs5j2HegyvJ6R/3UZ2wfR1lnhp0W01q9X
	ujnhYpZha3xxFa8Lx7cHLZsk37a+f/9Uy1t5utG/u2uOZ+TNec2125ntwm7v3ZbSDZN2++5Q
	CZ9/4sjnm3t6TXffP7GE9e+PrD0Xj/Jfmabtmb7NOeOj2KOJEYx1SizFGYmGWsxFxYkA1dWB
	O/0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV37Ky7BBtPOCli0XTnIbtG8eD2b
	xeWFl1gtehdcZbPY9Pgaq8XlXXPYLGac38dksWhZK7PFhN8X2Bw4PfbPXcPusXlJvcfsuz8Y
	Pfq2rGL0+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRt/H/ewF
	3TwVq75fYG1gfMzZxcjJISFgIrHmfSszhC0mceHeerYuRi4OIYFFjBJTHs9khHB+M0p0nPzM
	BlLFJqAm8eXLYXYQW0QgUmLP3YPsIEXMAg8ZJa4/Xg2WEBJwl9jQuJgJxOYU8JA4u+0HI4gt
	LJAksW3SX7B1LAKqEj+m9ILZvAK2EgfnXGWBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtUD0H
	0KnqEo/+6kLcYCSxZ9odZogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMEJ45n0DsZVDRaHGAU4GJV4eBUsXYKFWBPLiitzDzFKcDArifA+
	zwYK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wmeWVxBsam5gZWRqZWRiZmJuTJqwkznuw
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PA6nKJIxpfBc/VXGxzWpcjrqL//Xl+Kdcb1Rn99Yz5
	TkLvq90q03ZlnXGcwGX+vuyX0wRZlmNSeow3pr5YfeTxja9RCgJr3mlz9xTOjv5s/W72H8az
	k4Lafhr0n7OWCxFvOtl38M/Sci7FZfrTy5sdvRmnnjCfJ5z45eVj/yXNeZrG3YfiWJRYijMS
	DbWYi4oTARsU91lcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2014 1:01 PM, Vivek Gautam wrote:
> 
> Patch 'b8efdaf USB: EHCI: add check for wakeup/suspend race'
> adds a check for possible race between suspend and wakeup interrupt,
> and thereby it returns -EBUSY as error code if there's a wakeup
> interrupt.
> So the platform host controller should not proceed further with
> its suspend callback, rather should return immediately to avoid
> powering down the essential things, like phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Based on 'usb-next' branch of Greg's usb tree.
> 
>  drivers/usb/host/ehci-exynos.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index d1d8c47..a4550eb 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -212,6 +212,8 @@ static int exynos_ehci_suspend(struct device *dev)
>  	int rc;
> 
>  	rc = ehci_suspend(hcd, do_wakeup);
> +	if (rc)
> +		return rc;
> 
>  	if (exynos_ehci->otg)
>  		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> @@ -221,7 +223,7 @@ static int exynos_ehci_suspend(struct device *dev)
> 
>  	clk_disable_unprepare(exynos_ehci->clk);
> 
> -	return rc;
> +	return 0;
>  }
> 
>  static int exynos_ehci_resume(struct device *dev)
> --
> 1.7.10.4

