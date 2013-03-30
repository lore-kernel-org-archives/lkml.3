Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3C3WB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:01:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48064 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab3C3WBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:01:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, jacob.shin@amd.com
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
Date: Sat, 30 Mar 2013 23:08:56 +0100
Message-ID: <1656173.qmCdUDP7Pu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpon_C3LYe++cOb_9fgtz=DfQV_vWRNuH=UVXcKOO14GUhQ@mail.gmail.com>
References: <cover.1364398686.git.viresh.kumar@linaro.org> <2566297.LngxUqUYMZ@vostro.rjw.lan> <CAKohpon_C3LYe++cOb_9fgtz=DfQV_vWRNuH=UVXcKOO14GUhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 30, 2013 09:06:37 AM Viresh Kumar wrote:
> On 30 March 2013 07:47, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, March 27, 2013 09:28:56 PM Viresh Kumar wrote:
> 
> >> To test these over linux-next you need to revert following first:
> >> db9baec cpufreq: Get rid of "struct global_attr"
> >> 86bd6f0 cpufreq: governor: Implement per policy instances of governors
> >> 8ae67b1 cpufreq: Add per policy governor-init/exit infrastructure
> 
> > I've applied these two patches and re-applied the queue on top of them.
> >
> > All is in my linux-next branch now.
> 
> You were supposed to remove below patch too, which you missed :)
> 
> c7baa5e cpufreq: Get rid of "struct global_attr"

OK, I'll remove it.

And by the way, I'm no longer amused with the mess going on in the cpufreq land.

Please send me *patches*.  I'm not interested in git pointers.

Moreover, please send those patches in a way allowing me to figure out the
ordering without looking into your git tree.

If you have a number of outstanding cpufreq patches for me to apply, please
create a patch series out of them and send it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
