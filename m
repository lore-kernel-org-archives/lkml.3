Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3EDGP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 02:15:57 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54382 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3EDGP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 02:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <003001ce47c8$9ba8df10$d2fa9d30$@samsung.com>
References: <003001ce47c8$9ba8df10$d2fa9d30$@samsung.com>
Date: Sat, 4 May 2013 11:45:55 +0530
X-Google-Sender-Auth: rnIt6KTcTjARpfSV-qcaNwNu5Tg
Message-ID: <CAOh2x=mW7p+9rQNWPpXB5AcF3FJF84O_AMgdPJjY8v3=9iaM-A@mail.gmail.com>
Subject: Re: [PATCH 34/42] rtc: rtc-spear: remove unnecessary platform_set_drvdata()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 12:06 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-spear.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Thanks.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
