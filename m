Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbAEHoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 02:44:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbAEHoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 02:44:04 -0500
X-AuditID: cbfee68d-f79296d000004278-2a-54aa40c1b3d8
Message-id: <54AA40C7.3000506@samsung.com>
Date: Mon, 05 Jan 2015 13:14:07 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony nadackal <tony.kn@samsung.com>
Subject: Re: media: platform: s5p-jpeg: jpeg-hw-exynos4: Remove some unused
 functions
References: <1420231027-2714-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-reply-to: <1420231027-2714-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRvegw6oQg7cfBS16rz5ntPjx+gKb
	Re+Cq2wWmx5fY7W4vGsOm0XPhq2sFjPO72OyuLhO3uL0zpusFofftLNavLr4ismB22PzknqP
	vi2rGD3aG34yenzeJBfAEsVlk5Kak1mWWqRvl8CV8WWjbcE8gYp/V38yNjAe4u1i5OSQEDCR
	mHDtHguELSZx4d56ti5GLg4hgaWMErtn/WKCKWpc8I8ZIrGIUWL1xBdQVa1MEve/nWIGqeIV
	0JK43/kVbBSLgKrE1Lvv2EBsNgFdiSfv54LViApESFxZM4cRol5Q4sdkkNVcHCIC0xglriw8
	CjaVWWATk0RPy2+wDmGBcImurtNgdwgB2TsnfQbr5gSadG7HIlYQm1nATOLLy8NQtrzE5jVv
	wW6VELjFLnHlVic7xEkCEt8mHwJaxwGUkJXYdIAZ4jdJiYMrbrBMYBSbheSoWUjGzkIydgEj
	8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwKg8/e9Z7w7G2wesDzEKcDAq8fB6nFgZIsSa
	WFZcmXuI0RToionMUqLJ+cDYzyuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgXHDr25ju6iGY9bFYe8apjDfSJl2Mt/8c/6M7J8XH89gDW2+bbR6rlZ4
	w5Rrj/tXyFWH2s19pmuXz8WT5mO4+lFZ9rdfW7l6/N6WvZOyWxcmdGiFithMyQ7b53enaPxk
	lS73j1lrcWnW6h137zkoruF9lsHkajPPWqW/76mowHqF9b2NnqcYbJVYijMSDbWYi4oTAWCg
	x+7FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd2DDqtCDD49Z7fovfqc0eLH6wts
	Fr0LrrJZbHp8jdXi8q45bBY9G7ayWsw4v4/J4uI6eYvTO2+yWhx+085q8eriKyYHbo/NS+o9
	+rasYvRob/jJ6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowv
	G20L5glU/Lv6k7GB8RBvFyMnh4SAiUTjgn/MELaYxIV769m6GLk4hAQWMUqsnvgCymllkrj/
	7RRYFa+AlsT9zq8sIDaLgKrE1Lvv2EBsNgFdiSfv54LViApESFxZM4cRol5Q4sfkeywgg0QE
	pjFKXFl4FGwqs8AmJomelt9gHcIC4RJdXaeZQGwhIHvnpM9g3ZxAk87tWMQKYjMLmEl8eXkY
	ypaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBMf9M
	egfjqgaLQ4wCHIxKPLweJ1aGCLEmlhVX5h5ilOBgVhLhXXcLKMSbklhZlVqUH19UmpNafIjR
	FBgGE5mlRJPzgekoryTe0NjE3NTY1NLEwsTMUkmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qB
	0e2Yary0b00S8x63j6/eL5gva53+88jTjRqzT0z79e7SkW881pUuFjNYEg46zvMR27vcr6mq
	5PK89l7VuXOcjx4UUnhbuqTi+dapJU98+2N3v12kndsZzpdcGy52KWdfQ/qSfdemmExcfLdo
	pqV6zd+a4sUHenuZAhRivGUP8Z24sypvRsm2KiWW4oxEQy3mouJEAL2ho2QPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Tony Nadackal

Hi Rickard,

On Saturday 03 January 2015 02:07 AM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> exynos4_jpeg_set_timer_count() exynos4_jpeg_get_frame_size() exynos4_jpeg_set_sys_int_enable() exynos4_jpeg_get_fifo_status()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> ---
> drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |   35 ---------------------
>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h |    5 ---
>   2 files changed, 40 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> index ab6d6f4..5685577 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> @@ -163,15 +163,6 @@ unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
>   	return int_status;
>   }
>
> -unsigned int exynos4_jpeg_get_fifo_status(void __iomem *base)
> -{
> -	unsigned int fifo_status;
> -
> -	fifo_status = readl(base + EXYNOS4_FIFO_STATUS_REG);
> -
> -	return fifo_status;
> -}
> -
>   void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
>   {
>   	unsigned int	reg;
> @@ -186,18 +177,6 @@ void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
>   					base + EXYNOS4_JPEG_CNTL_REG);
>   }
>
> -void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value)
> -{
> -	unsigned int	reg;
> -
> -	reg = readl(base + EXYNOS4_JPEG_CNTL_REG) & ~(EXYNOS4_SYS_INT_EN);
> -
> -	if (value == 1)
> -		writel(reg | EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
> -	else
> -		writel(reg & ~EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
> -}
> -

Above function will be needed for enabling JPEG support on Exynos7 SoC. 
There is already inflight patch [1] which will be using it.

1: https://patchwork.kernel.org/patch/5505391/


Thanks,
Pankaj Dubey
