Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaDYQca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:32:30 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40549 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaDYQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <1398420888-5506-6-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
	<1398420888-5506-6-git-send-email-ch.naveen@samsung.com>
Date: Fri, 25 Apr 2014 09:32:23 -0700
X-Google-Sender-Auth: XVynLMdG1DMHuZLbSnW3tGfIFZY
Message-ID: <CAD=FV=Uv7NdY8vw0atu1Szyz5-VoFbqeM6rc2Jk_LBBzBxGkuw@mail.gmail.com>
Subject: Re: [PATCH 5/5] iio: exynos_adc: do a reinit_completion before the conversion
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen

On Fri, Apr 25, 2014 at 3:14 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> Add reinit_completion() before the wait_for_completion_timeout in
> raw_read() call.
>
> Change-Id: I70fa00841bc49eba838a5bd6779015844297dfdb

Again, remove Change-Id (in the previous patch, too).

> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/iio/adc/exynos_adc.c |    1 +
>  1 file changed, 1 insertion(+)

Seems reasonable.

Reviewed-by: Doug Anderson <dianders@chromium.org>
