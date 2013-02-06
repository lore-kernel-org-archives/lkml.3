Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3BFMwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:52:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:51742 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3BFMwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:52:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Replace down_differential tuner with adj_up_threshold
Date: Wed, 06 Feb 2013 13:58:37 +0100
Message-ID: <2305264.MrLQGjTkB4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=ksAibntsfGm51r+JiQOAhHYYmHF1o=_H97fSKqGcq_mQ@mail.gmail.com>
References: <511173DF.8060308@semaphore.gr> <CAOh2x=ksAibntsfGm51r+JiQOAhHYYmHF1o=_H97fSKqGcq_mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 11:05:45 AM Viresh Kumar wrote:
> On Wed, Feb 6, 2013 at 2:34 AM, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> > In order to avoid the calculation of up_threshold - down_differential
> > every time that the frequency must be decreased, we replace the
> > down_differential tuner with the adj_up_threshold which keeps the
> > difference across multiple checks.
> >
> > Update the adj_up_threshold only when the up_theshold is also updated.
> >
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > ---
> >  drivers/cpufreq/cpufreq_governor.h |  2 +-
> >  drivers/cpufreq/cpufreq_ondemand.c | 16 ++++++++++------
> >  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> Makes sense.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks, applied to bleeding-edge.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
