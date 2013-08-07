Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3HGWn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:43:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59770 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab3HGWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:43:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OPP: rename functions? (was [PATCH] OPP: Export opp_add())
Date: Thu, 08 Aug 2013 00:53:46 +0200
Message-ID: <1999730.6oshSp9AC9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <52026C66.2080509@ti.com>
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org> <1611420.5h2rr9N0mt@vostro.rjw.lan> <52026C66.2080509@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 07, 2013 10:48:54 AM Nishanth Menon wrote:
> Rafael,
> offline question:

Not really offline. :-)

> On 08/06/2013 09:15 AM, Rafael J. Wysocki wrote:
> > On Tuesday, August 06, 2013 08:08:20 AM Nishanth Menon wrote:
> >> change in subject to reflect new discussion.
> >>
> >> On 05:53-20130806, Randy Dunlap wrote:
> >>> On 08/03/2013 02:25 AM, Viresh Kumar wrote:
> 
> >>>> +EXPORT_SYMBOL_GPL(opp_add);
> >>>
> >>> Could it be renamed to pm_opp_add() or power_opp_add() ?
> >>> The name is a bit too unspecific IMO.
> >> Though this has nothing specific with this patch, an interesting point.
> >>
> >> git grep -w opp . showed drivers/tty/n_tty.c,
> >> drivers/sbus/char/openprom.c and arch/powerpc/kvm/mpic.c using
> >> variables named opp to mean what ever they had in context. rest(around
> >> 40 odd files) seem to use opp as in Documentation/power/opp.txt..
> >>
> >> We could go with a pm_ prefix or even dev_pm_opp_ prefix to be more
> >> specific, though I prefer just pm_. If Rafael and others are ok, I can
> >> post a series out.
> >
> > Yup, that would be useful.  I'm for dev_pm_opp_ if that matters.
> 
> Given that there would be quiet a few conflicts, do you have a 
> suggestion around what baseline I should submit this?

Well, ideally, on top of 3.12-rc1 when it's out and put it into linux-next
right after that.

Thanks,
Rafael

