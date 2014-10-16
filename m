Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaJPXfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:35:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41178 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaJPXfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:35:09 -0400
X-AuditID: cbfee68f-f791c6d000004834-bd-5440562a7ef8
Message-id: <54405629.2090702@samsung.com>
Date: Fri, 17 Oct 2014 08:35:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkRFcrzCHEoKGN32LqwydsFmeXHWSz
	OPq7wKJ3wVU2i/tfjzJabHp8jdXi8q45bBYzzu9jsli16w+jA6fH7IaLLB5/n19n8dg56y67
	x6ZVnWwed67tYfPYvKTeo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDJO3P7GVvBdoKJn9wW2
	Bsa7vF2MnBwSAiYSfb8eskHYYhIX7q0Hsrk4hASWMkqs2T6dEaaoY99LFojEdEaJnxu3QVW9
	ZpSYtm43C0gVr4CWxPxlL9lBbBYBVYmTTY3MIDYbUHz/ixtgK0QFwiRWTr8CVS8o8WPyPTBb
	RMBO4sbqh8wgQ5kFFjFJbHi4iQkkISyQLLF012JWiG1TGSUu/T8HNolTIEBiwpeTYBuYBXQk
	9rdOY4Ow5SU2r3kLNklC4C27xP6T51ghThKQ+Db5ENA6DqCErMSmA8wQv0lKHFxxg2UCo9gs
	JEfNQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIExurpf8/6dzDePWB9iFGA
	g1GJh1cj2D5EiDWxrLgy9xCjKdAVE5mlRJPzgQkhryTe0NjMyMLUxNTYyNzSTEmcd6HUz2Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPE3FBc9z1lr7WrRXqAcb2A5ff26U5ddikKkRYzY
	M+8ceGFzwPl1FOuprWZVi9STKlpdn9paV+wp7L73dkJSwtfXUwPln2QWTvRcwSxUdjTq8sVV
	bTvWH773cl1ryUr25XOsnP5PmCb8Vj5w9eS7/KY//ymfeFihWiCZoa3AGHWV8Wr4tUDpS0os
	xRmJhlrMRcWJABHYi6XQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoK5WmEOIwdplbBZTHz5hszi77CCb
	xdHfBRa9C66yWdz/epTRYtPja6wWl3fNYbOYcX4fk8WqXX8YHTg9ZjdcZPH4+/w6i8fOWXfZ
	PTat6mTzuHNtD5vH5iX1Hn1bVjF6fN4kF8AR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsIYx48Ttb2wF3wUqenZfYGtgvMvbxcjJISFgItGx7yULhC0mceHeerYuRi4OIYHp
	jBI/N26Dcl4zSkxbtxusildAS2L+spfsIDaLgKrEyaZGZhCbDSi+/8UNNhBbVCBMYuX0K1D1
	ghI/Jt8Ds0UE7CRurH7IDDKUWWARk8SGh5uYQBLCAskSS3ctZoXYNpVR4tL/c2CTOAUCJCZ8
	OQm2gVlAR2J/6zQ2CFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIEJ4JnUjsYVzZYHGIU4GBU4uHVCLYPEWJNLCuuzD3EKMHBrCTC+1zDIUSINyWx
	siq1KD++qDQntfgQoykwDCYyS4km5wOTVF5JvKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU
	7NTUgtQimD4mDk6pBkadN8LSB/iW77X6cfyqp0tAc9IuyYgq1o4XdjEWIetrLSvFLoj7bLtj
	96q6iY1N61DKWrl3hisWaFuc5kryM4wzu5SeNl1LsHqTqC6/hlnkkuMLWja/UQ0SdJn/YhJ7
	+a6LrN8tuouKT5Ys2rg3mZc7ybR0ia6b2f07nUZfo9J528xL7ka4KLEUZyQaajEXFScCADrj
	wPYaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 10/16/2014 07:13 PM, Javier Martinez Canillas wrote:
> The regulator framework has a set of helpers functions to be used when
> the system is entering and leaving from suspend but these are not called
> on Exynos platforms. This means that the .set_suspend_* function handlers
> defined by regulator drivers are not called when the system is suspended.
> 
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/mach-exynos/suspend.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index cc8d237..ee9a8e0 100644
> --- a/arch/arm/mach-exynos/suspend.c
> +++ b/arch/arm/mach-exynos/suspend.c
> @@ -20,6 +20,7 @@
>  #include <linux/io.h>
>  #include <linux/irqchip/arm-gic.h>
>  #include <linux/err.h>
> +#include <linux/regulator/machine.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/hardware/cache-l2x0.h>
> @@ -443,6 +444,22 @@ static int exynos_suspend_enter(suspend_state_t state)
>  
>  static int exynos_suspend_prepare(void)
>  {
> +	int ret;
> +
> +	/*
> +	 * REVISIT: It would be better if struct platform_suspend_ops
> +	 * .prepare handler get the suspend_state_t as a parameter to
> +	 * avoid hard-coding the suspend to mem state. It's safe to do
> +	 * it now only because the suspend_valid_only_mem function is
> +	 * used as the .valid callback used to check if a given state
> +	 * is supported by the platform anyways.
> +	 */
> +	ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
> +	if (ret) {
> +		pr_err("Failed to prepare regulators for system suspend\n");
> +		return ret;
> +	}
> +
>  	s3c_pm_check_prepare();
>  
>  	return 0;
> @@ -451,6 +468,7 @@ static int exynos_suspend_prepare(void)
>  static void exynos_suspend_finish(void)
>  {
>  	s3c_pm_check_cleanup();
> +	regulator_suspend_finish();
>  }
>  
>  static const struct platform_suspend_ops exynos_suspend_ops = {
> 

Looks good to me.

Reviewed-by: Chanwoo Choi<cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
