Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3D2KLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:11:47 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59334 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3D2KLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:11:46 -0400
MIME-Version: 1.0
In-Reply-To: <000601ce44ba$47b62bd0$d7228370$@samsung.com>
References: <000601ce44ba$47b62bd0$d7228370$@samsung.com>
Date: Mon, 29 Apr 2013 15:41:45 +0530
X-Google-Sender-Auth: U-f7HMyLKOGDnTEsh6anisQNS98
Message-ID: <CAOh2x=mYY9+JKo2or=nnowUXRa8LEYmjScbEo+kjPXjDADzcXw@mail.gmail.com>
Subject: Re: [PATCH RESEND 5/5] watchdog: sp805_wdt: use devm_clk_get()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 2:46 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> Use devm_clk_get() to make cleanup paths more simple.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/sp805_wdt.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)

You should have used get_maintainers.pl for getting the cc list.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
