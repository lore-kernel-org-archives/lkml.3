Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3C1KXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:23:16 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59098 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3C1KXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <001501ce2b8f$b6e39950$24aacbf0$%han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
	<001501ce2b8f$b6e39950$24aacbf0$%han@samsung.com>
Date: Thu, 28 Mar 2013 15:53:14 +0530
X-Google-Sender-Auth: wJ-peik6WeOopzIbD7LhUVG4JJA
Message-ID: <CAOh2x==GXtnxrj_DH+79MkFOWR2RK7Ei4SbZL6dmXkEo8yoWeg@mail.gmail.com>
Subject: Re: [PATCH 6/8] rtc: rtc-spear: convert spear_rtc_driver to dev_pm_ops
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 2:09 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> Instead of using legacy suspend/resume methods, using newer dev_pm_ops
> structure allows better control over power management.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-spear.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
