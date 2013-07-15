Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3GOAHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:07:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42719 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3GOAHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:07:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] power: Fix comment typo in pm_wakeup.h
Date: Mon, 15 Jul 2013 02:17:46 +0200
Message-ID: <11477417.WFRCSCsf6O@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373518558-670-1-git-send-email-cw00.choi@samsung.com>
References: <1373518558-670-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 01:55:58 PM Chanwoo Choi wrote:
> This patch fix typo (sorce -> source)
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Applied.

Thanks,
Rafael


> ---
>  include/linux/pm_wakeup.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
> index 569781f..a0f7080 100644
> --- a/include/linux/pm_wakeup.h
> +++ b/include/linux/pm_wakeup.h
> @@ -36,8 +36,8 @@
>   * @last_time: Monotonic clock when the wakeup source's was touched last time.
>   * @prevent_sleep_time: Total time this source has been preventing autosleep.
>   * @event_count: Number of signaled wakeup events.
> - * @active_count: Number of times the wakeup sorce was activated.
> - * @relax_count: Number of times the wakeup sorce was deactivated.
> + * @active_count: Number of times the wakeup source was activated.
> + * @relax_count: Number of times the wakeup source was deactivated.
>   * @expire_count: Number of times the wakeup source's timeout has expired.
>   * @wakeup_count: Number of times the wakeup source might abort suspend.
>   * @active: Status of the wakeup source.
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
