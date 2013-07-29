Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3G2Awk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 20:52:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47269 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3G2Awe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 20:52:34 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-c4-51f5bcd0eaa8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kefeng Wang'" <wangkefeng.wang@huawei.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com,
        "'Luis Henriques'" <luis.henriques@canonical.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <1374919513-15356-1-git-send-email-wangkefeng.wang@huawei.com>
In-reply-to: <1374919513-15356-1-git-send-email-wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] video: remove unused variable dev
Date: Mon, 29 Jul 2013 09:52:32 +0900
Message-id: <009601ce8bf5$e88bfda0$b9a3f8e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJPnaqycqCJG6TqcJyoBH2YBXjj05h4r3tQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zfd0Le74GGix6p2ZxcOdMdovLCy+x
	Wpzo+8BqcXnXHDaLp/seMVmse/iCyWL9/FtsFo2f7zM6cHjMauhl82g58pbV49WFOywefVtW
	MXocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujL4Ld5gK1nFU/Hr6lr2B8SlbFyMnh4SAicTr
	/++hbDGJC/fWA9lcHEICyxgl9h/+xg5T9K7xDyNEYhGjxJvfvawQzi9Gid/9e1hBqtgE1CS+
	fDkM1iEiECUx8e5sFpAiZoEXjBLT/twC2yEk4CWx5tMNMJtTwFtizcFeRhBbWMBM4vz7a8wg
	NouAqsTWByeABnFw8ApYSszuZAIJ8woISvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiEsVJHac
	fc0IcYORxI4ZT6DqRST2vXgH9oGEQCOHxIk7yxkhdglIfJt8iAVkl4SArMSmA1BzJCUOrrjB
	MoFRYhaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJ6gk7GO8d
	sD7EmAy0fiKzlGhyPjAp5JXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBkeH3GqnZP5kuH897ze+YEmFe9WXvTp34yotMotNSpfeGH5r/dAHrm52C
	DQ8SqxsLtA1sI/zY8ub/mDJBpXX1jxdCfv3bPQzak/5N3XhOSX1+jvzEw/z35spY3FRTC7fP
	vT2xw8T6xpLjCxSdG3+WGK6f9Gxuxomkadu6f4uubu5m8N9d38H2UomlOCPRUIu5qDgRAO+g
	RjgAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAd0Le74GGvTsUrI4uHMmu8XlhZdY
	LU70fWC1uLxrDpvF032PmCzWPXzBZLF+/i02i8bP9xkdODxmNfSyebQcecvq8erCHRaPvi2r
	GD2O39jO5PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6q
	rZKLT4CuW2YO0EVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoy+C3eY
	CtZxVPx6+pa9gfEpWxcjJ4eEgInEu8Y/jBC2mMSFe+uB4lwcQgKLGCXe/O5lhXB+MUr87t/D
	ClLFJqAm8eXLYXYQW0QgSmLi3dksIEXMAi8YJab9uQU2VkjAS2LNpxtgNqeAt8Sag71gK4QF
	zCTOv7/GDGKzCKhKbH1wAmgQBwevgKXE7E4mkDCvgKDEj8n3WEBsZgEtifU7jzNB2PISm9e8
	ZYa4VEFix9nXjBA3GEnsmPEEql5EYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcMp4JrWDcWWDxSFGAQ5GJR7eh05fAoVYE8uKK3MPMUpwMCuJ
	8HIYfQ0U4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgOssriTc0NjEzsjQyszAyMTcnTVhJ
	nPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsb9jL0Ch2LLnj06e+bp9qOip1UubEj6Zm5nwN2f
	Lvizfp7403c/dpru21dqzpI+qaek7JPU6ktPLKRF2GKWRPg5mRRucZIterCTP+zeE2W97/rR
	+5L+qF4vbmA1qj268eEbF7FJHxZvWSQU7bLmUUl7eOO6X69swq+wOnMb7p9nu59X77VjgYQS
	S3FGoqEWc1FxIgAHGvbPXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 27, 2013 7:05 PM, Kefeng Wang wrote:
> 
> Due to commit: e21d2170f [video: remove unnecessary platform_set_drvdata()],
> variable dev is unused, so remove it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/video/vga16fb.c | 1 -
>  1 file changed, 1 deletion(-)

CC'ed Luis Henriques.


Hi Kefeng Wang,

The same patch was submitted by Luis Henriques 2 weeks ago.
Also, the patch was already applied by Tomi Valkeinen.

Best regards,
Jingoo Han

> 
> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 830ded4..2827333 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
> 
>  static void vga16fb_destroy(struct fb_info *info)
>  {
> -	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
>  	iounmap(info->screen_base);
>  	fb_dealloc_cmap(&info->cmap);
>  	/* XXX unshare VGA regions */
> --
> 1.8.2.2


