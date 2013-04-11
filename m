Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab3DKUhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56480 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3DKU0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, arvind.chauhan@arm.com,
        Arnd Bergmann <arnd.bergmann@linaro.org>, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 9/9] powerpc: cpufreq: move cpufreq driver to drivers/cpufreq
Date: Thu, 11 Apr 2013 22:33:50 +0200
Message-ID: <3219488.Pmor8goo2e@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomHFgMBAHax=jC_LNd8Gay9aWja+64An7QxnNpaPuuSQQ@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org> <20130411065957.GB31465@quad.lixom.net> <CAKohpomHFgMBAHax=jC_LNd8Gay9aWja+64An7QxnNpaPuuSQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 12:32:50 PM Viresh Kumar wrote:
> On 11 April 2013 12:29, Olof Johansson <olof@lixom.net> wrote:
> > That's not very nice this late in the staging cycle. Give the powerpc
> > guys a little more time than a single day to come back with test results,
> > please.
> 
> Yes we are waiting indefinitely for an Ack from powerpc guys.. If we can
> get a Ack soon, we will get it in 3.10 otherwise next cycle.

Well, I'll be traveling from Saturday morning onwards until the end of the
next week and my window for taking stuff into v3.10 closes in 16 hours.
Whatever is not ready (i.e. ACKed in this particular case) before that time,
won't be taken.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
