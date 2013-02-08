Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3BHCpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:45:20 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34122 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207Ab3BHCpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <3542.1360264736@turing-police.cc.vt.edu>
References: <9180.1360172675@turing-police.cc.vt.edu>
	<17233164.aBDzy1OViI@vostro.rjw.lan>
	<CAOh2x=mjTX3hM0uxJh9qk=9OUWqZaAjAV57r2H4AgH+ZjY+eCg@mail.gmail.com>
	<3542.1360264736@turing-police.cc.vt.edu>
Date: Fri, 8 Feb 2013 08:15:17 +0530
Message-ID: <CAKohpoks+XA0bb33D53ZRxJaHzNk66++tBOrVhzMEhaM=7sbWA@mail.gmail.com>
Subject: Re: next-20130206 cpufreq - WARN in sysfs_add_one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Valdis.Kletnieks@vt.edu
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 00:48,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 07 Feb 2013 13:11:52 +0530, Viresh Kumar said:
>
>> First of all i want to confirm something about your system. I am sure it is a
>> multi-policy system (or multi cluster system). i.e. there are more than one
>> clock line for different cpus ? And so multiple struct policy exist
>> simultaneously.
>
> Hmm.. it's a bog-standard Dell Latitude E6500 laptop, with a single
> Core2 Duo P8700 CPU (one die, 2 cores, no HT). It's apparently able
> to clock both cores at different speeds (one core running busy at 2540mhz
> and the other idling at 800mhz), if that's what you mean by multiple
> clock lines.

Perfect!! So, when the cpus can manage different freqs, we have multiple
struct policies for them per cpu.

> In any case, next-20130206 complained, and with this patch added I see
> nothing in dmesg and cpufreq is acting properly on both cores, so:
>
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Thanks.

> (btw - I had to hand-apply your patch, as it showed up white-space
> damaged.  Three lines wrapped, and tabs converted to spaces).

I know that and feeling bad for you :(

I gave you this because of my mails issue :)

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-valdis
