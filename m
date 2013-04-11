Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3DKFMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:12:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23174 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3DKFMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:12:21 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-8e-51664633979e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-14-git-send-email-arnd@arndb.de>
In-reply-to: <1365638712-1028578-14-git-send-email-arnd@arndb.de>
Subject: Re: [PATCH 13/30] video/s3c: move platform_data out of arch/arm
Date: Thu, 11 Apr 2013 14:12:18 +0900
Message-id: <003301ce3673$23ae2f80$6b0a8e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac42SHpvEpDekeWjQq2dvIBR/FGzVAAKkMNA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ11jt7RAgwkvpCz+TjrGbvHykKbF
	5YWXWC16F1xls9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHDg9fv+axOixeUm9R9+WVYwe
	x29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK2N1zy32gi7Oisff1zE1MM5k72Lk5JAQMJH4f3sX
	E4QtJnHh3nq2LkYuDiGBZYwS+1dfZ4MpOjC1nRkiMZ1R4llbDzuE84tR4szBe6wgVWwCahJf
	vhwGGysi4Clx5uQCFpAiZoEbjBLdM94BFXEAdZRJHOj2B6nhFHCUuP/5Jli9sICHxPPWC2Bn
	sAioStxe+ZgFxOYVsJXobdnJCmELSvyYfA8sziygJbF5WxMrhC0vsXnNW2aQ8RIC6hKP/upC
	nGAkcXPHfHaIEhGJfS/eMYKcIyHwl13i9/Y/7BC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnA
	KDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKExPPEHYz3D1gf
	YkwGWj+RWUo0OR+YDvJK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwHiYv3+ivnlT2bsljA91FA8FWC1c4Bjzel/JxwU19jZRIkouTKIaXskyyzr4
	GvOT7MuCnjRXWVru+Jx9MDy9LjBZ/sri9N9f6vLnbZvqcKjpljPrQvabP1f8dW77y9icXbpA
	s50n1+pm9fprM6ZuOJcmE3S6NW7/wuYFll4GwoyMr5jfz6sRUGIpzkg01GIuKk4EAKD6W6X9	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV1jt7RAgwNHxSz+TjrGbvHykKbF
	5YWXWC16F1xls9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHDg9fv+axOixeUm9R9+WVYwe
	x29sZ/L4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG6p5b7AVd
	nBWPv69jamCcyd7FyMkhIWAicWBqOzOELSZx4d56ti5GLg4hgemMEs/aetghnF+MEmcO3mMF
	qWITUJP48uUwWLeIgKfEmZMLWECKmAVuMEp0z3gHVMQB1FEmcaDbH6SGU8BR4v7nm2D1wgIe
	Es9bLzCB2CwCqhK3Vz5mAbF5BWwlelt2skLYghI/Jt8DizMLaEls3tbECmHLS2xe85YZZLyE
	gLrEo7+6ECcYSdzcMZ8dokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcLJ4Jr2DcVWDxSFGAQ5GJR7eEw2pgUKsiWXFlbmHGCU4mJVEeLl2
	AoV4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jI8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qB0Ymz7+3qo1s02lZd+rpA/XFAzWPbX0wLHzH4cYr6XjRt
	9PWaveFgkahZrGHehc2XhDaqLw1QXbv/87/fS65Z19SI8Z3beylmm9XZgpRX4TM+bU3bI6Wy
	yjRQc967rNuzyzIZn07SmGvTUCFwI0+eN0Cbdamu2Z2lFwSfPrj6MP/hhJCttyfpmiqxFGck
	GmoxFxUnAgABvP+jWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 9:05 AM, Arnd Bergmann wrote:
> 
> The s3c-fb driver requires header files from the samsung platforms
> to find its platform_data definition, but this no longer works on
> multiplatform kernels, so let's move the data into a new header
> file under include/linux/platform_data.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Jingoo Han <jg1.han@samsung.com>
> ---
>  arch/arm/plat-samsung/include/plat/fb.h | 50 +-----------------------------
>  drivers/video/s3c-fb.c                  |  3 +-
>  include/linux/platform_data/video_s3c.h | 54 +++++++++++++++++++++++++++++++++
>  3 files changed, 56 insertions(+), 51 deletions(-)
>  create mode 100644 include/linux/platform_data/video_s3c.h
> 

[.....]

> +struct s3c_fb_platdata {
> +	void	(*setup_gpio)(void);
> +
> +	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
> +	struct fb_videomode     *vtiming;
> +
> +	u32			 vidcon0;
> +	u32			 vidcon1;
> +};
> + 

There is an unnecessary space.
When the patch is merged, this space should be removed.


Best regards,
Jingoo Han

> +#endif
> --
> 1.8.1.2

