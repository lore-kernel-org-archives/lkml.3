Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbbANIc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:32:29 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51035 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbbANIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:32:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix coding style error
Date: Wed, 14 Jan 2015 09:32:20 +0100
Message-ID: <1839300.4mCDOMkO8E@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421223642-4465-1-git-send-email-patrick.boettcher@posteo.de>
References: <1421223642-4465-1-git-send-email-patrick.boettcher@posteo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:VgdxvDvpV1DfJBxXrMJ3XSji8gcTzwqPeosNgmq4rCwITNa3zpc
 wyu/04xDJpY13SeFXyQeRh34qDbn7kC0/G8CmsiTe4AXTJYIGIH6Ay4oWPi8EYHetxomDgy
 Iy3E2OQZVdg10LYm3aHHLV6FGkvh5PJxC9nPOsQe0YYhzI/gXMnbec31dmIHbDbleQe1jXG
 NHRTNU7QB65tojK7jE/sg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2015 09:20:42 Patrick Boettcher wrote:
> diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
> index 1532a86..9a2aaf8 100644
> --- a/drivers/staging/android/sync_debug.c
> +++ b/drivers/staging/android/sync_debug.c
> @@ -96,7 +96,8 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
>                    sync_status_str(status));
>  
>         if (status <= 0) {
> -               struct timespec64 ts64 = ktime_to_timespec64(pt->base.timestamp);
> +               struct timespec64 ts64 =
> +                   ktime_to_timespec64(pt->base.timestamp);
>  
>                 seq_printf(s, "@%lld.%09ld", (s64)ts64.tv_sec, ts64.tv_nsec);
>         }
> 

You are not really improving readability by just wrapping the line
arbitrarily though.

If you're offended by the long line, better rework the code so the long
line is not needed.

	Arnd
