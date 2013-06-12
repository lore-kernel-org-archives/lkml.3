Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3FLOtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:49:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3FLOtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:49:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 00/11] CPUFreq Kconfig fixes
Date: Wed, 12 Jun 2013 16:49:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
References: <cover.1371022830.git.viresh.kumar@linaro.org> <201306121447.00139.arnd@arndb.de> <CAKohpont-8ZNDWx0n1G8ks=evfoJi3kQ5idjmeguyT8BWgTY4w@mail.gmail.com>
In-Reply-To: <CAKohpont-8ZNDWx0n1G8ks=evfoJi3kQ5idjmeguyT8BWgTY4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121649.41656.arnd@arndb.de>
X-Provags-ID: V02:K0:VBCAO6KyqY2Rx3K7QkL99JsA17k6nkE4o6uMKxWFDiO
 6o5fPiFFD/YWdfkwcW3BeoKwsheGJGPaQml4duyUc5DlQVpgt3
 AOiOLeOmWe4td5DXWacHIk5QEougjTT4EIztBm/htedjqPFizL
 mq5HNGFP6IfzLkRs51ePzvgSYDI9sZOX0cl92ujpe26tghMFrI
 YJMVUZQnLpKwl8zXAfLAiGHfVFnTMDje3RLwQJEO1tZAe7asQZ
 L96UhZ7XVnb4mJVs9r14AyZjrs0O8XWWxIYToonpOvR0pzNeWN
 NpicL92MIvchYRHlOUZYFtXg8/I/E865rqnZP9mrXtxHT1WkWp
 JFFpO9M+DblGcA4Dpac0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013, Viresh Kumar wrote:
> 
> On 12 June 2013 18:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 12 June 2013, Viresh Kumar wrote:
> >> Recently Arnd sent few fixes where drivers were using APIs from freq_table.c but
> >> haven't selected CPU_FREQ_TABLE. Based on that, I just crossed checked all the
> >> places where it should be selected and where it shouldn't be. These are fixes
> >> around that.
> >>
> >> I have applied these in my cpufreq-kconfig-fixes branch. Will send you a pull
> >> request separately once I get some Acks (will wait for few days).
> >
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> >
> > I don't see a patch for big.LITTLE in either linux-next or this series. Did you
> > miss that or has it just not made into linux-next yet?
> 
> My ARM branch was pulled in by Rafael, 2 days back. Don't know why didn't
> you saw that.


Ah, it seems we haven't had a new linux-next since friday.

	Arnd
