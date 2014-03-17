Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaCQBFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:05:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61836 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaCQBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:05:07 -0400
X-AuditID: cbfee68e-b7f566d000002344-95-53264a4047d7
Message-id: <53264E2D.8000701@samsung.com>
Date: Mon, 17 Mar 2014 10:21:49 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it
Subject: Re: [PATCH] drivers: rtc: rtc-s3c: remove NO_IRQ macro
References: <1394017975-4963-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1394017975-4963-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zQ10HL7Vgg0cdahZLLl5lt7i8aw6b
	xaKtX9gt9nd2MDqweOyZeJLNo2/LKkaP6fN+Mnl83iQXwBLFZZOSmpNZllqkb5fAlfHq33/W
	gqscFeeXFjUwNrF3MXJySAiYSCzdNI8JwhaTuHBvPVsXIxeHkMAyRoknC+awwhRN294KlZjO
	KLHrwTwWkISQwGtGiUNt6SA2r4CWxLP5X9lAbBYBVYmJrVfBNrAJ6Eo8eT+XGcQWFQiT2DS9
	jxWiXlDix+R7YHNEBLQlOi/fA4szC4RIHJ34grGLkYNDWMBeYuZsT4hV7hLnHz0CO5RTwENi
	zeImRohya4mVk7ZB2fISm9e8ZQa5U0JgFbvE+Y8b2CHuEZD4NvkQC8hMCQFZiU0HmCH+kpQ4
	uOIGywRGsVlILpqFZOwsJGMXMDKvYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJpb4djDcP
	WB9iTAZaOZFZSjQ5HxiLeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBUclPPuHX/KUxPBK3rr9OkDJn8Nh2J1Pylv3SVvUjvw7LuLW5Zp3VT3p0
	K5yFfV1mS8W3q05yc495zp5S9HJndc3m+JOWJVqtG3PlFvBGcQd2BJpGK278dMFPzCI8PPTC
	Pz/vnWYC75cUaR2ewqlu+XRbce9Hu8TmLcp1pf+jHXdX2C08VSyvxFKckWioxVxUnAgAeVZn
	XLsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoK6Dl1qwwbKFShZLLl5lt7i8aw6b
	xaKtX9gt9nd2MDqweOyZeJLNo2/LKkaP6fN+Mnl83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5jx6t9/1oKrHBXnlxY1MDaxdzFyckgImEhM297KBmGLSVy4tx7I
	5uIQEpjOKLHrwTwWkISQwGtGiUNt6SA2r4CWxLP5X8EaWARUJSa2XgUbxCagK/Hk/VxmEFtU
	IExi0/Q+Voh6QYkfk++BzRER0JbovHwPLM4sECJxdOILxi5GDg5hAXuJmbM9IVa5S5x/9IgJ
	xOYU8JBYs7iJEaLcWmLlpG1QtrzE5jVvmScwCsxCsmEWkrJZSMoWMDKvYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAiO1GfSOxhXNVgcYhTgYFTi4Z2grBYsxJpYVlyZe4hRgoNZSYQ3wRwo
	xJuSWFmVWpQfX1Sak1p8iDEZGAATmaVEk/OBSSSvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhjznGS35alaHtvY6JeReD5h5ssFrQXV4k93xNnbJXzY3hj3
	bqFkXfPH/dIG5RcifH1irghFXGY02hK4lU89pFP1XY232xRbnQMyrVzXQjQOasUGnFafWWHi
	uktbfe+aSc13w3xVjRm5C9WP2U/f4N6T7VSdeXmP4uVzx04d2+vqVeGz//rVeCWW4oxEQy3m
	ouJEAFP0picYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 08:12 PM, Pankaj Dubey wrote:
> NO_IRQ may be defined as '(unsigned int) -1' in some architectures
> (arm, sh ...), and either may not be defined in some architectures
> (arm64) which can enable RTC_DRV_S3C.
> Also since platform_get_irq returns err-code in case of any error,
> we do not need to intialize s3c_rtc_alarmno and s3c_rtc_tickno.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/rtc/rtc-s3c.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index 7afd373..cf2ebdd 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -48,8 +48,8 @@ struct s3c_rtc_drv_data {
>   
>   static struct clk *rtc_clk;
>   static void __iomem *s3c_rtc_base;
> -static int s3c_rtc_alarmno = NO_IRQ;
> -static int s3c_rtc_tickno  = NO_IRQ;
> +static int s3c_rtc_alarmno;
> +static int s3c_rtc_tickno;
>   static enum s3c_cpu_type s3c_rtc_cpu_type;
>   
>   static DEFINE_SPINLOCK(s3c_rtc_pie_lock);

Gentle Ping.

-- 
Best Regards,
Pankaj Dubey

