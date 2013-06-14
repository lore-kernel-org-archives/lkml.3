Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3FNHSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:18:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3FNHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:18:00 -0400
X-AuditID: cbfee68e-b7f276d000002279-96-51bac39eb3da
Message-id: <51BAC39D.6020909@samsung.com>
Date: Fri, 14 Jun 2013 16:17:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: class: Add NULL pointer checking for removing
 notifier block.
References: <1371175897-3001-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1371175897-3001-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkUHfe4V2BBo92slp0nn3CbHF51xw2
	i8+9RxgtbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MNxv/sBWsYa84Pl+kgbGf
	rYuRg0NCwESieRtPFyMnkCkmceHeeqAwF4eQwFJGiQdTFrJAJEwkTn3YyQyRmM4osXfdEiYI
	5wWjxL7W+4wgVbwCWhL3j3xgA7FZBFQlZn9uYAax2YDi+1/cAIuLCoRJrJx+hQWiXlDix+R7
	YLYIUM21x+/A5jALpEosOLWQHcQWFoiR+HXkMliNkIC7xPr2n+wgV3MKeEgsfxAMUa4jsb91
	GhuELS+xec1bsEMlBKazS3yZuZAV4h4BiW+TD7FAfCwrsekAM8RjkhIHV9xgmcAoNgvJRbOQ
	jJ2FZOwCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFxc/rfs74djDcPWB9iTAZaOZFZ
	SjQ5Hxh3eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgtLquacTNnLZZ2vwZA8vi9UueBrw7XSjUXv6Q/eC1hyGVmkdm+vCIK8j8e2Kol/hX+vvS
	rP3TWnfnOcn9Xcj8ujeyqKrn/46GFwcPr/l12Mvq3BsN4YxbjYtnL5MrkdX6mJR7qUlgsYCt
	dKhXqM6htyVRu1cdFWnivnX07bcCN+nENsFlciKWSizFGYmGWsxFxYkAw8NEIrECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd25h3cFGux6bm3RefYJs8XlXXPY
	LD73HmG0uN24gs2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM95s/MNWsIa94vh8kQbGfrYuRk4OCQETiVMfdjJD2GISF+6tB4pzcQgJTGeU2Ltu
	CROE84JRYl/rfUaQKl4BLYn7Rz6AdbMIqErM/twA1s0GFN//4gZYXFQgTGLl9CssEPWCEj8m
	3wOzRYBqrj1+BzaHWSBVYsGphewgtrBAjMSvI5fBaoQE3CXWt/8EinNwcAp4SCx/EAxRriOx
	v3UaG4QtL7F5zVvmCYwCs5BsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	guPymfQOxlUNFocYBTgYlXh4Ey7sDBRiTSwrrsw9xCjBwawkwhv+FyjEm5JYWZValB9fVJqT
	WnyIMRkYABOZpUST84EpI68k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGMNmmDBmt/0uu68a3OWS7DeTm/2i70ah69Pu7XfNEhdpfuXjMnvT+5JCD6ajtWX8
	xWsOimp8+ash6O/M9ufIRsF/FQu1Lp+/pjfttN0UvipHiznKD1/8CbF8/+3aV1VfXbYSFtdb
	AjIm5+5U7lpa7tt0guPcPmv7uXH5t4M3/l1/61z/6xT/JCWW4oxEQy3mouJEALX9hoIPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 11:11 AM, Jonghwa Lee wrote:
> This patch adds NULL pointer checking of extcon device to 'extcon_unregister
> _interest' which unregisters extcon notifier block.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 8c69803..23f11ea 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -491,7 +491,7 @@ EXPORT_SYMBOL_GPL(extcon_register_interest);
>   */
>  int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
>  {
> -	if (!obj)
> +	if (!obj || !obj->edev)
>  		return -EINVAL;
>  
>  	return raw_notifier_chain_unregister(&obj->edev->nh, &obj->internal_nb);
> 

Applied it.

Thanks,
Chanwoo Choi
