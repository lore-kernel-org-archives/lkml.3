Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbbA0RQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:16:33 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34406 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbA0RQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:16:32 -0500
MIME-Version: 1.0
In-Reply-To: <1422372141-2440-1-git-send-email-john.stultz@linaro.org>
References: <1422350658.14015.9.camel@x220>
	<1422372141-2440-1-git-send-email-john.stultz@linaro.org>
Date: Tue, 27 Jan 2015 09:16:31 -0800
X-Google-Sender-Auth: 0uSIbCRHoi0YhfRoETgELTbA7hg
Message-ID: <CAGXu5jJRNoXGYjmnWPFG_of6FS+TyoEHRV05tb94_wP9Cmi1Zg@mail.gmail.com>
Subject: Re: [PATCH] staging: Remove logger and alarm-dev from android Makefile
From: Kees Cook <keescook@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Rom Lemarchand <romlem@google.com>,
        Mark Salyzyn <salyzyn@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg Hackmann <ghackmann@google.com>, Elliott Hughes <enh@google.com>,
        Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 7:22 AM, John Stultz <john.stultz@linaro.org> wrote:
> My previous patches deleting logger and alarm-dev from staging
> missed the android Makefile.
>
> This patch cleans up the Makefile to remove the now non-existent
> files.
>
> Cc: Rom Lemarchand <romlem@google.com>,
> Cc: Mark Salyzyn <salyzyn@google.com>,
> Cc: Kees Cook <keescook@chromium.org>,
> Cc: Android Kernel Team <kernel-team@android.com>,
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
> Cc: Greg Hackmann <ghackmann@google.com>,
> Cc: Elliott Hughes <enh@google.com>,
> Cc: Todd Poynor <toddpoynor@google.com>,
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Looks right to me. :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/staging/android/Makefile | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
> index 479b2b8..c7b6c99 100644
> --- a/drivers/staging/android/Makefile
> +++ b/drivers/staging/android/Makefile
> @@ -3,10 +3,8 @@ ccflags-y += -I$(src)                  # needed for trace events
>  obj-y                                  += ion/
>
>  obj-$(CONFIG_ASHMEM)                   += ashmem.o
> -obj-$(CONFIG_ANDROID_LOGGER)           += logger.o
>  obj-$(CONFIG_ANDROID_TIMED_OUTPUT)     += timed_output.o
>  obj-$(CONFIG_ANDROID_TIMED_GPIO)       += timed_gpio.o
>  obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)        += lowmemorykiller.o
> -obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)   += alarm-dev.o
>  obj-$(CONFIG_SYNC)                     += sync.o sync_debug.o
>  obj-$(CONFIG_SW_SYNC)                  += sw_sync.o
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security
