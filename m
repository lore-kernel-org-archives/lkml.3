Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaDWR1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:27:50 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35317 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbaDWR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:27:46 -0400
MIME-Version: 1.0
In-Reply-To: <1398158578-122556-1-git-send-email-bintian.wang@huawei.com>
References: <1398158578-122556-1-git-send-email-bintian.wang@huawei.com>
Date: Wed, 23 Apr 2014 10:27:45 -0700
X-Google-Sender-Auth: h9_r1n0QChNLXAvYUjBfEy2eptE
Message-ID: <CAMbhsRT3B5oxBRneP+hDfSTspiRS8h+u=CF-gsugg-vh8cqRzw@mail.gmail.com>
Subject: Re: [PATCH] staging/android: Remove ram_console.h
From: Colin Cross <ccross@android.com>
To: Bintian Wang <bintian.wang@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Li Zefan <lizefan@huawei.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:22 AM, Bintian Wang <bintian.wang@huawei.com> wrote:
> ram_console is replaced by pstore and pstore_ram drivers,
> and there is no code to use this head file, so remove it.
>
> Signed-off-by: Bintian Wang <bintian.wang@huawei.com>
> ---
>  drivers/staging/android/ram_console.h |   22 ----------------------
>  1 file changed, 22 deletions(-)
>  delete mode 100644 drivers/staging/android/ram_console.h
>
> diff --git a/drivers/staging/android/ram_console.h b/drivers/staging/android/ram_console.h
> deleted file mode 100644
> index 9f1125c..0000000
> --- a/drivers/staging/android/ram_console.h
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -/*
> - * Copyright (C) 2010 Google, Inc.
> - *
> - * This software is licensed under the terms of the GNU General Public
> - * License version 2, as published by the Free Software Foundation, and
> - * may be copied, distributed, and modified under those terms.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - */
> -
> -#ifndef _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_
> -#define _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_
> -
> -struct ram_console_platform_data {
> -       const char *bootinfo;
> -};
> -
> -#endif /* _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_ */
> --
> 1.7.9.5
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Acked-by: Colin Cross <ccross@android.com>
