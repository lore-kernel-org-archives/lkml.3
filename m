Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3JUW2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:28:23 -0400
Received: from [212.160.235.94] ([212.160.235.94]:52721 "EHLO hydra.sisk.pl"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3JUW2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:28:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
Date: Tue, 22 Oct 2013 00:39:45 +0200
Message-ID: <4207904.oBhTxYOkzS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomXxodtUvGyo3SXRAVE8W9nZiYSU9Zak+zDt9+rOjonxw@mail.gmail.com>
References: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org> <CAKohpo=wHN1wTsh-UfYMO-XBDtj0=SFuxjTPqw9aZAG6iRJ0mQ@mail.gmail.com> <CAKohpomXxodtUvGyo3SXRAVE8W9nZiYSU9Zak+zDt9+rOjonxw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 21, 2013 12:43:32 PM Viresh Kumar wrote:
> On 13 October 2013 06:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 13/10/2013, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> -> What about this:
> >>
> >>       /*
> >>        * The core will not set policy->cur, because cpufreq_driver->get is NULL,
> >>        * so we need to set it here.  However, we have to guess it, because the
> >>        * current speed is unknown and not detectable via IO ports.
> >>        */
> >
> > Far better. Attached again. Thanks.
> 
> Have you missed applying this one? Attached again..

I don't think I've missed it.  It should be commit 1bab64d in my tree.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
