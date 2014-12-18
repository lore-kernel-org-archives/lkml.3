Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaLRK0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:26:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25808 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLRK0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:26:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-1b-5492abe9d4c0
Message-id: <5492ABE7.1060900@samsung.com>
Date: Thu, 18 Dec 2014 11:26:47 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: nick <xerofoify@gmail.com>, inki.dae@samsung.com
Cc: linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dh09.lee@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, tomi.valkeinen@ti.com, kgene@kernel.org,
        plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Subject: Re: Weird/Unneeded call to msleep in exynos_mipi_dsi_wr_data in
 exynos_mipi_dsi_common.c
References: <54920A54.2060608@gmail.com>
In-reply-to: <54920A54.2060608@gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xy7ovV08KMXj+W9Xi+nk7i0n3J7BY
	vH5haNH/+DWzxdmmN+wWmx5fY7U40feB1eLyrjlsFjPO72OyWPfwBZPF+vm32Cx+TZF14PHY
	Oesuu8erC3dYPDat6mTz2Lyk3qNvyypGj+M3tjN5fN4kF8AexWWTkpqTWZZapG+XwJWxbvkB
	xoLPLBXNr/YwNjC+Ze5i5OSQEDCR+N70mBXCFpO4cG89WxcjF4eQwFJGiTeNu1kgnM+MEi0N
	PYwgVbwCWhI3DzWwgNgsAqoSDxrfM4HYbAIeEtO+94BNFRWIkPiw6isbRL2gxI/J98DqRYC2
	neq5BzaUWeAvo8TNtfPAmoUFkiUu/XwJ1iAkoCHRdecV0EkcHJwCmhI3H4mAhJkF1CUmzVvE
	DGHLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkCj5
	uoNx6TGrQ4wCHIxKPLwJuZNChFgTy4orcw8xSnAwK4nwRucAhXhTEiurUovy44tKc1KLDzEy
	cXBKNTCaXZi/J0vxSYDP/AORpm3rBQTNQgVDTn9P2eyxQuiTrWzQfOWHXHbaQsa/jh8Vjcis
	fmtRujBr5+v4GOYtxSpfypYtqI4rZgjyvTzjwLzw6I6WcsO1U8xXTPpY6ZbZ9XK30O/LS/ze
	5m1aIj8nbJ2awLLrfW7+1l9q8iWetvyQ/BJY/kjzfbwSS3FGoqEWc1FxIgCVCVjocAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2014 23:57, nick wrote:
> Greetings Fellow Maintainers,
> Sorry if I wasting your time but it seems there is a unneeded call to msleep

Hi,

1. Please describe exactly why do you think this is not needed.
2. Do you have Exynos-based hardware to test your changes?

Best regards,
Krzysztof

> and rather trivial fix me to fix in the file,exynos_mipi_dsi_common.c for the function,exynos_mipi_dsi_wr_data . If there is a valid reason for this call please let me known when any of you  have some free time. Otherwise I will send in a patch to remove this unneeded
> call to msleep.
> Thanks,
> Nick  


