Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3FXLfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:35:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48961 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3FXLfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:35:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [GIT PULL] ARM: CPUFreq updates for 3.11
Date: Mon, 24 Jun 2013 13:45:15 +0200
Message-ID: <1662523.HdXbLYrd2q@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomdnEgDcAExoyN1b4vohHNEg3NDH1mM8NWG8gQoPvff+Q@mail.gmail.com>
References: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com> <7195611.gCcafMWC85@vostro.rjw.lan> <CAKohpomdnEgDcAExoyN1b4vohHNEg3NDH1mM8NWG8gQoPvff+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 04:40:27 PM Viresh Kumar wrote:
> On 24 June 2013 16:29, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > In your original series that patch was the last one.  What made you change your
> > mind and put it in front?
> 
> I initially thought that this one would break git bisect (code would
> compile, but would fail) for platforms whose code I have fixed in
> this patchset.
> 
> But that is true only for failure cases, otherwise code would work as
> normal.
> 
> And hence kept this at the top this time.

Well, it should go last.  Also I'd prefer to apply it directly.

Please check my comment in there too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
