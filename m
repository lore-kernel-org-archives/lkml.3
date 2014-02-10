Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBJGkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:40:41 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61813 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaBJGkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <19098109.K5Vqu3vXYV@daeseok-laptop.cloud.net>
References: <19098109.K5Vqu3vXYV@daeseok-laptop.cloud.net>
Date: Mon, 10 Feb 2014 15:40:39 +0900
Message-ID: <CAHb8M2BRycK4zQv9bFzT7PJH=bbgd8a5airZiJdJR3aghA85ww@mail.gmail.com>
Subject: Re: [PATCH] staging : android : sync : fix a checkpatch warning
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>, Brian Swetland <swetland@google.com>
Cc: konkers <konkers@android.com>, "john.stultz" <john.stultz@linaro.org>,
        rdunlap <rdunlap@infradead.org>, standby24x7 <standby24x7@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC+ Joe Perches.

2014-02-10 14:58 GMT+09:00 Daeseok Youn <daeseok.youn@gmail.com>:
> From 16140b1ec1b1e1060f74707e4a6661aface81a14 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Mon, 10 Feb 2014 14:36:48 +0900
> Subject: [PATCH] staging : android : sync : fix a checkpatch warning
>
> - WARNING: missing space after return type
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/android/sync.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> index 62e2255b..6ee8d69 100644
> --- a/drivers/staging/android/sync.h
> +++ b/drivers/staging/android/sync.h
> @@ -53,7 +53,7 @@ struct sync_timeline_ops {
>         const char *driver_name;
>
>         /* required */
> -       struct sync_pt *(*dup)(struct sync_pt *pt);
> +       struct sync_pt * (*dup)(struct sync_pt *pt);
>
>         /* required */
>         int (*has_signaled)(struct sync_pt *pt);
> --
> 1.7.9.5
>
>
