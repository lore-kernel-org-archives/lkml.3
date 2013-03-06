Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3CFNjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:39:31 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45970 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab3CFNjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:39:14 -0500
MIME-Version: 1.0
In-Reply-To: <009001ce1a3f$e3d015d0$ab704170$%han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
	<009001ce1a3f$e3d015d0$ab704170$%han@samsung.com>
Date: Wed, 6 Mar 2013 21:39:12 +0800
X-Google-Sender-Auth: qY01Kx3vnSPqM9kZhzGioPTGHwQ
Message-ID: <CAOh2x=meurvO1dQMgQ=v0Rr5ET9REkew6rtJkGQNSGackdBhgg@mail.gmail.com>
Subject: Re: [PATCH V2 22/30] rtc: rtc-spear: use devm_rtc_device_register()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 3:54 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> devm_rtc_device_register() is device managed and makes cleanup
> paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - used 'struct device *dev' as the first argument
>
>  drivers/rtc/rtc-spear.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
