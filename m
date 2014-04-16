Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161282AbaDPOEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:04:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60054 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbaDPOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:03:58 -0400
Date: Wed, 16 Apr 2014 15:03:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry
 macro for iteration
Message-ID: <20140416140351.GE19671@lee--X1>
References: <534DB213.7080802@semaphore.gr>
 <20140416105121.GR4754@lee--X1>
 <CAKohpongiw9kZJDBsnp4U5obzX_W-sWHX3GoKd3STtQmsw6GcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpongiw9kZJDBsnp4U5obzX_W-sWHX3GoKd3STtQmsw6GcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The cpufreq core now supports the cpufreq_for_each_entry macro helper
> >> for iteration over the cpufreq_frequency_table, so use it.
> >>
> >> It should have no functional changes.
> >>
> >> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> >> ---
> >>  drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
> >>  1 file changed, 8 insertions(+), 11 deletions(-)
> >
> > Applied untested by me.
> 
> Wouldn't build. Let it go via Rafael.

Rafael, would you mind creating a branch from this patch set that we
can both pull from please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
