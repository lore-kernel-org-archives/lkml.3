Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3EGOzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:55:43 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47511 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3EGOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8Xu8+d7fxtnC0sdQnTDtrZo8jhB8JJ4b2Lp4SYqcjG4A@mail.gmail.com>
References: <CAPgLHd8Xu8+d7fxtnC0sdQnTDtrZo8jhB8JJ4b2Lp4SYqcjG4A@mail.gmail.com>
Date: Tue, 7 May 2013 20:25:41 +0530
Message-ID: <CAK9yfHxvF4vnfrWrkt9mr=XGriPg6DVetWyH87sXzDFoxvFRHg@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: fix error return code in exynos_drm_ipp_set_property()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie,
        yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei Yongjun,

On 7 May 2013 18:54, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> ipp_create_cmd_work() return ERR_PTR() on error and never return
> NULL, so use IS_ERR() instead of IS_ERR_OR_NULL().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

I have submitted a patch [1] to use IS_ERR instead of IS_ERR_OR_NULL()
for all incorrect instances in this driver.
Please base your patch fixing the return code on top of my patch.

[1] http://lists.freedesktop.org/archives/dri-devel/2013-April/038059.html

-- 
With warm regards,
Sachin
