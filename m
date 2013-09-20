Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3ITUFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:05:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60629 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab3ITUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:05:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
Date: Fri, 20 Sep 2013 22:16:49 +0200
Message-ID: <1413415.ibnkd89WIV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQUDwkQOt+rO8vbJW6hv3swP1n5kP3dT_rESoWUj5G6ANw@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org> <CAE9FiQWm=Db4e8nYdVJzpirmV2EfKxEYYRHo6ggTtX0CY3-hhg@mail.gmail.com> <CAE9FiQUDwkQOt+rO8vbJW6hv3swP1n5kP3dT_rESoWUj5G6ANw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 20, 2013 12:30:19 PM Yinghai Lu wrote:
> On Fri, Sep 20, 2013 at 10:12 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> I *think* we can just drop the module requesting stuff entirely, because it
> >> doesn't seem to work anyway and udev is handling this for us.
> >
> Yes. looks like acpi_processor_load_module() is not needed.
> udev will do the work.

OK, I'll cut a patch to drop that stuff.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
