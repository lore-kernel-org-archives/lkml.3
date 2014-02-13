Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBMGlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 01:41:36 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:52035 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaBMGlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 01:41:35 -0500
MIME-Version: 1.0
In-Reply-To: <dda85a5e41fbb1995fe3bda810a7a8297ccf1dcb.1390370582.git.viresh.kumar@linaro.org>
References: <dda85a5e41fbb1995fe3bda810a7a8297ccf1dcb.1390370582.git.viresh.kumar@linaro.org>
Date: Thu, 13 Feb 2014 12:11:33 +0530
Message-ID: <CAKohpokF5k5epGoSA+JhO0=imK0gjE296bi0Rrh2sNuTOmXB_A@mail.gmail.com>
Subject: Re: [PATCH Resend] PM: Remove unnecessary !!
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2014 11:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Double ! or !! are normally required to get 0 or 1 out of a expression. A
> comparision always returns 0 or 1 and hence there is no need to apply double !
> over it again.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/power/suspend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 62ee437..90b3d93 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -39,7 +39,7 @@ static const struct platform_suspend_ops *suspend_ops;
>
>  static bool need_suspend_ops(suspend_state_t state)
>  {
> -       return !!(state > PM_SUSPEND_FREEZE);
> +       return state > PM_SUSPEND_FREEZE;
>  }
>
>  static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);

Ping!!
