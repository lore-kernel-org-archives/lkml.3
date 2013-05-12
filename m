Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3ELPQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:16:37 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60608 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3ELPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <1368041688-29986-1-git-send-email-bp@alien8.de>
References: <1368041688-29986-1-git-send-email-bp@alien8.de>
Date: Sun, 12 May 2013 20:46:34 +0530
X-Google-Sender-Auth: qkHkZdg7MI9U2rRIbTwHW_6Ehz8
Message-ID: <CAOh2x=kLJ3NVN177KTWjZikkZb8Q8RQjye4qrUT=PCdCj2jSgg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, ondemand: Remove leftover debug line
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> I don't see how the virtual address of the tuners pointer would be of
> any help to anyone so remove it.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index b0ffef96bf77..4b9bb5def6f1 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -547,7 +547,6 @@ static int od_init(struct dbs_data *dbs_data)
>         tuners->io_is_busy = should_io_be_busy();
>
>         dbs_data->tuners = tuners;
> -       pr_info("%s: tuners %p\n", __func__, tuners);
>         mutex_init(&dbs_data->mutex);
>         return 0;
>  }

Sorry for this message :(

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
