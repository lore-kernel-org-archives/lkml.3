Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3FFJAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:00:42 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48313 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130606105814.3495e3a9@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370502472-7249-2-git-send-email-l.majewski@samsung.com>
	<CAKohpokYdwutUX-zkHLs3bKmLg=Fb7WvKcwvfek9Q8k=XXs3bw@mail.gmail.com>
	<20130606105814.3495e3a9@amdc308.digital.local>
Date: Thu, 6 Jun 2013 14:30:39 +0530
Message-ID: <CAKohpo=fLmDog5KVjijEZNakpjLvrKy=S+nv+GQyCc2brcnO1w@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: Define cpufreq_set_drv_attr_files() to add
 per CPU sysfs attributes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2013 14:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> I'm confused here.
>
> So you want to check dev_attr for NULL just after:
> drv_attr = cpufreq_driver->attr;
> if (!drv_attr)
>         goto error;
>
> and skip the check at the while loop:
> while ((drv_attr) && (*drv_attr))
>
> to
>
> while ((*drv_attr))
>
> Am I correct?

Bingo!!
