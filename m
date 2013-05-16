Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3EPUnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:43:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52283 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3EPUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:42:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
Date: Thu, 16 May 2013 22:51:25 +0200
Message-ID: <4482296.g7Mb85DDVP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpom=_i8MgWy7eoa+wBtaRZ288CMfcYsGBi-4qzu4ZqR3uw@mail.gmail.com>
References: <cover.1368679353.git.viresh.kumar@linaro.org> <6691801.RqjZrI7EgH@vostro.rjw.lan> <CAKohpom=_i8MgWy7eoa+wBtaRZ288CMfcYsGBi-4qzu4ZqR3uw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 16, 2013 02:09:46 PM Viresh Kumar wrote:
> On 16 May 2013 14:16, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, May 16, 2013 10:39:55 AM Viresh Kumar wrote:
> >> Hi Rafael,
> >
> > Hi,
> >
> >> Here are few more fixes for 3.10-rc2.
> >
> > I'm actually going to sent the for-rc2 request today, so these are for -rc3.
> 
> Okay. No issues.

While I kind of understand why you want [3/3] to go into 3.10, I'm wondering
about the other two patches.  Why exactly are they needed now?

And speaking of patch [3/3], if you paste kernel logs into changelogs, please
remove the time stamps (unless they are relevant to the problem being fixed).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
