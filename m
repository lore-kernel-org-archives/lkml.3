Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3EMMFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:05:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44463 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3EMMFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:05:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] cpufreq, ondemand: Remove leftover debug line
Date: Mon, 13 May 2013 14:14:04 +0200
Message-ID: <3026061.6K3iqZoMUx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=kLJ3NVN177KTWjZikkZb8Q8RQjye4qrUT=PCdCj2jSgg@mail.gmail.com>
References: <1368041688-29986-1-git-send-email-bp@alien8.de> <CAOh2x=kLJ3NVN177KTWjZikkZb8Q8RQjye4qrUT=PCdCj2jSgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 12, 2013 08:46:34 PM Viresh Kumar wrote:
> On Thu, May 9, 2013 at 1:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> > From: Borislav Petkov <bp@suse.de>
> >
> > I don't see how the virtual address of the tuners pointer would be of
> > any help to anyone so remove it.
> >
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > ---
> >  drivers/cpufreq/cpufreq_ondemand.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index b0ffef96bf77..4b9bb5def6f1 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -547,7 +547,6 @@ static int od_init(struct dbs_data *dbs_data)
> >         tuners->io_is_busy = should_io_be_busy();
> >
> >         dbs_data->tuners = tuners;
> > -       pr_info("%s: tuners %p\n", __func__, tuners);
> >         mutex_init(&dbs_data->mutex);
> >         return 0;
> >  }
> 
> Sorry for this message :(
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied to the linux-next branch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
