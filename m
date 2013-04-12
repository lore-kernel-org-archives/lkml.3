Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3DLOYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:24:23 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57520 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3DLOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:24:21 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKohpom7Mn8aQZTUx-_fQF+9KWste0uYsZcaQ5rcM6ab45-0+g@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
	<CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
	<CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
	<CA+icZUWH5Ni9koj4V8Ws8jJ7smwmU7JuUWBFh=aiCqkrCpqB5A@mail.gmail.com>
	<CAKohponzmLzPN8ua3p4TCt2waZCQCd+4Znh+tSQ4MBjcy+Ss6A@mail.gmail.com>
	<CA+icZUW12caZHDfgCV6E-1T4ExBPmu5bBNSqCzDwjUeidfRUPA@mail.gmail.com>
	<CA+icZUUEExm5Mktxoj6=UdzBe5HUzskktKWdHNOKaFXVHaySBg@mail.gmail.com>
	<CA+icZUW2LQmWMdaVjf5oE8y3zCq8Y2829WM9dwDKxA42N5tVDQ@mail.gmail.com>
	<CAKohpom7Mn8aQZTUx-_fQF+9KWste0uYsZcaQ5rcM6ab45-0+g@mail.gmail.com>
Date: Fri, 12 Apr 2013 16:24:19 +0200
Message-ID: <CA+icZUULhGR61V=wCXYctzBaM7Dei0-zGXApmfqQyiByzd5-cw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 10:23 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 10 April 2013 11:44, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> I found this "[RFC PATCH] kbuild: Build linux-tools package with 'make
>> deb-pkg'" from February 2012.
>> Can't say what happened to it...
>
> Sedat,
>
> Sorry for being late. I am down with Fever and throat infection since few days.
> Still struggling with it..
>
> There are few things i tried. Firstly the tag: next-20130326 is bad as there are
> some bad commits in cpufreq core in it.
>
> I then tried latest linux-next/master on my Thinkpad (model name        : Intel(R)
> Core(TM) i7-2640M CPU @ 2.80GHz) and couldn't boot it up. My ubuntu
> just hanged.
>
> Then i tried Rafael's linux-next branch
>
> 079576f Merge branch 'pm-cpufreq-next' into linux-next
>
> And couldn't find any issues with it. I am easily able to remove/add cpus at
> runtime..
>
> Can you give this branch a try?
>

OK, you seem to be well again, nice to hear.

I was doing the whole week spring-cleaning in the apartment of my parents.
Now, I have some minutes for a compilation run.

I guess "cpufreq: Call __cpufreq_governor() with correct policy->cpus
mask" could be the correct fix, but will try the GIT branch you have
mentioned.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=e4969ebac83fdea78d89c779331396728a4e6199

> --
> viresh
