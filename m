Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab3IBMeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:34:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52222 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3IBMd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:33:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Mon, 02 Sep 2013 14:44:47 +0200
Message-ID: <59922407.8jDJDIWysm@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <11222156.oKTjYXFZjG@vostro.rjw.lan> <CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 01, 2013 09:30:49 PM Viresh Kumar wrote:
> On 1 September 2013 18:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, September 01, 2013 10:56:02 AM Viresh Kumar wrote:
> >> We can't take a big lock around __cpufreq_governor() as this causes recursive
> >> locking for some cases. But calls to this routine must be serialized for every
> >> policy.
> >
> > Care to explain here why it must be serialized?
> 
> Yes, added that to the attached patches (Added reported-by too):

OK, the attached patches queued up for 3.12.

Thanks,
Rafael

