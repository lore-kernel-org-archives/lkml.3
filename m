Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaCQART (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:17:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaCQARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:17:15 -0400
X-AuditID: cbfee68e-b7f566d000002344-29-53263f069c84
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
 <1394789408-14648-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394789408-14648-6-git-send-email-cw00.choi@samsung.com>
Subject: Re: [PATCHv3 5/8] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
Date: Mon, 17 Mar 2014 09:17:10 +0900
Message-id: <001501cf4176$3d23daa0$b76b8fe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8/aMdOM1H1q499RS+OmxkbEdH9/wCDM9cA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zQ102e7Vgg76zChYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlpcXniJ1eJs0xt2i4VtS1gsLu+aw2bxufcIo8WM8/uYLJZev8hkcbtxBZvF
	mx9nmSwmTF/LYvF4xVt2i1cH21gcBDzWzFvD6LFy+Rc2j8V7XjJ5/Fy+nd2jb8sqRo/jN7Yz
	eXzeJOexcW5oAEcUl01Kak5mWWqRvl0CV8byRbtZC95yV9zdeJutgfEVZxcjJ4eEgInErjtv
	GCFsMYkL99azdTFycQgJLGOUmHLoOTtM0aRHL5kgEtMZJTqug3SAOL8ZJaau3sAMUsUmoCbx
	5cthsA4RAS2JiZ0zwTqYBWYzS/w+MQ9qbiOjxIRNu8A6OAXcJL7uWssCYgsL+Ek8/fMELM4i
	oCpxqPETWJxXwFbi2YGNULagxI/J98BsZqAN63ceZ4Kw5SU2r3kL1MsBdKu6xKO/uhBHGEns
	+9DMDlEiIrHvxTuwqyUEDnBIrDn2gAVil4DEt8mHWCB6ZSU2HWCGeFlS4uCKGywTGCVmIdk8
	C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkMTRt4Px5gHrQ4zJQOsn
	MkuJJucDE09eSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamAMFllu3/r77UOt5FPWbjXvdM9MVGBfsEDirIfWSXHxh/MDXay48ksO79LS6NuZwNa4
	fpdQdHbZ0Tbjdk9vr5NLPnev+3ydae+W8xWv96+R+3lympH5d3WGhSIHAjy3rTM5feFG3ezL
	ndOND+ndF203fRi/3vqQVsKpC2pTv5koSQhI64jzVoYqsRRnJBpqMRcVJwIA837D3zIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jQV02e7Vgg50vpSw6en6zWFz/8pzV
	Yv6Rc6wW516tZLS4vPASq8XZpjfsFgvblrBYXN41h83ic+8RRosZ5/cxWSy9fpHJ4nbjCjaL
	Nz/OMllMmL6WxeLxirfsFq8OtrE4CHismbeG0WPl8i9sHov3vGTy+Ll8O7tH35ZVjB7Hb2xn
	8vi8Sc5j49zQAI6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZyxftZi14
	y11xd+NttgbGV5xdjJwcEgImEpMevWSCsMUkLtxbz9bFyMUhJDCdUaLj+htGCOc3o8TU1RuY
	QarYBNQkvnw5zA5iiwhoSUzsnMkEUsQsMJtZ4veJeVDtjYwSEzbtAuvgFHCT+LprLQuILSzg
	J/H0zxOwOIuAqsShxk9gcV4BW4lnBzZC2YISPybfA7OZgTas33mcCcKWl9i85i1QLwfQreoS
	j/7qQhxhJLHvQzM7RImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4LT0TGoH48oGi0OMAhyMSjy8E5TVgoVYE8uKK3MPMUpwMCuJ8CaYA4V4
	UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5gy80riDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBUexW2lyn++oKL7omP2NvuGG+4qe8U4ZVRO/Rt0x3a4895MrK
	va6Zk2n/q2Pu9GybVxd+HS9cuHrV/4pKC5b9zyZdcNaN4UvwvcjiN6OW+0n0/qfRJYHyHy9p
	RJ9eu1F0Tl/ts3uLPodWTHhzr/l7+cFNzZ9F1Q54fjkQtLt9av7O417h6zVkzZVYijMSDbWY
	i4oTASbk+d2PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 14, 2014 6:30 PM, Chanwoo Choi wrote:
> 
> This patch use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos4_bus.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index 60539e8..e5d2c5a 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -1247,6 +1247,7 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
>  static int exynos4_busfreq_resume(struct device *dev)
>  {
>  	struct busfreq_data *data = dev_get_drvdata(dev);
> @@ -1254,9 +1255,10 @@ static int exynos4_busfreq_resume(struct device *dev)
>  	busfreq_mon_reset(data);
>  	return 0;
>  }
> +#endif
> 
>  static const struct dev_pm_ops exynos4_busfreq_pm = {
> -	.resume	= exynos4_busfreq_resume,
> +	SET_SYSTEM_SLEEP_PM_OPS(NULL, exynos4_busfreq_resume)

Hi Chanwoo Choi,

How about using SIMPLE_DEV_PM_OPS instead of SET_SYSTEM_SLEEP_PM_OPS?
SIMPLE_DEV_PM_OPS is simpler as below.

static SIMPLE_DEV_PM_OPS(exynos4_busfreq_pm, NULL, exynos4_busfreq_resume);

However, if runtime pm functions will be added later,
SIMPLE_DEV_PM_OPS is not necessary.

Best regards,
Jingoo Han

>  };
> 
>  static const struct platform_device_id exynos4_busfreq_id[] = {
> --
> 1.8.0

