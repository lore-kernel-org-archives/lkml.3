Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaESXFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:05:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63117 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752137AbaESXFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:05:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: powernow-k8: Suppress checkpatch warnings
Date: Tue, 20 May 2014 01:22:12 +0200
Message-ID: <2759682.X7CU1JTh4P@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponF4KKjq5JwTSjeHKPfyfvi=2Qpv8+6NNODPO1DxDVrvQ@mail.gmail.com>
References: <536FB2B8.1060505@semaphore.gr> <CAKohponF4KKjq5JwTSjeHKPfyfvi=2Qpv8+6NNODPO1DxDVrvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 09:52:06 AM Viresh Kumar wrote:
> On 11 May 2014 22:56, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> > Suppress the following checkpatch.pl warnings:
> >
> > - WARNING: Prefer pr_err(... to printk(KERN_ERR ...
> > - WARNING: Prefer pr_info(... to printk(KERN_INFO ...
> > - WARNING: Prefer pr_warn(... to printk(KERN_WARNING ...
> > - WARNING: quoted string split across lines
> > - WARNING: please, no spaces at the start of a line
> >
> > Also, define the pr_fmt macro instead of PFX for the module name.
> >
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Queued up for 3.16, thanks!

> > ---
> >
> > Changes v1 -> v2
> >         - Use pr_err_once instead of printk_once
> >         - Change missing_pss_msg to macro (because pr_err_once
> >         doesn't compile otherwise)
> >         - Put one pr_err message in a single line instead of two
> >         - Ignore "line over 80 characters" warnings
> >         - Change the word "Fix" in the subject of the patch to
> >         "Suppress" as the patch doesn't really fix anything
> >
> >  drivers/cpufreq/powernow-k8.c | 180 +++++++++++++++++-------------------------
> >  drivers/cpufreq/powernow-k8.h |   2 +-
> >  2 files changed, 74 insertions(+), 108 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
