Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3HZOqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:46:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33462 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3HZOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:46:51 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-8d-521b6a59b316
Date: Mon, 26 Aug 2013 16:46:39 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
Message-id: <20130826164639.490ecc82@amdc308.digital.local>
In-reply-to: <CAKohpo=h9rW+FVrsmqee0oY_KK+h9x8o40b7LvAGzX1s4KsZNA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <CAKohpondC1BuODMauBsBKZtL=9sSDUSB6nXFKSoLWJG_xgO+iw@mail.gmail.com>
 <20130826091114.78ea4f61@amdc308.digital.local>
 <2003732.zyaEDD5Bdr@vostro.rjw.lan>
 <CAKohpo=h9rW+FVrsmqee0oY_KK+h9x8o40b7LvAGzX1s4KsZNA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAd3ILOkggwNHzCw2zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBa3G1ewWfQv7GWyePKw
	j81i41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4MpZeWcxWMIujYtKGC+wNjKvZuhg5OSQETCTed/QzQ9hiEhfurQeKc3EICSxilOjZ
	vZoZwmlnkpi98As7SBWLgKrEm/93GUFsNgE9ic93nzJ1MXJwiAhoSby8mQpSzyywk0Vi2ftb
	jCBxYQEPiZbjcSDlvALWEpfuXAULcwoES/zp8YMYv5pJonHSc7Dx/AKSEu3/fkAdZCdx7tMG
	doheQYkfk++xgNjMQKs2b2tihbDlJTavecs8gVFwFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOKKeSe9gXNVgcYhRgINRiYc3gE06SIg1say4MvcQowQHs5IIL0cq
	UIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjxgsXO6Re
	7Xp+6MrGh6XZO6su/GEzZzxj+d6Oya7Sq9I8WXmH0nd/w5USb01naxkoiL5lX74m4+Bl6/bv
	0T1ee624qqatnzOpVufesnVrfcVKH33fOo9VrODXgu59yz8vcL5xrTJ1dd/1y6sYGtaodaro
	vX4i90TvG+OMosk9XHVbkk6Uvd/6WomlOCPRUIu5qDgRAEhIs/ykAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 19:30:07 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 August 2013 18:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, August 26, 2013 09:11:14 AM Lukasz Majewski wrote:
> >> On Mon, 26 Aug 2013 12:36:47 +0530 Viresh Kumar
> >> viresh.kumar@linaro.org wrote,
> >> > On 26 August 2013 12:32, Lukasz Majewski <l.majewski@samsung.com>
> >> > wrote:
> >> > > On Mon, 26 Aug 2013 10:58:53 +0530 Viresh Kumar
> >> > > viresh.kumar@linaro.org wrote,
> >> > >> Some minor nitpicking, nothing much :)
> >> > >
> >> > > Is there any chance to pull those corrected patches to v3.12?
> >> >
> >> > Only Rafael can decide :)
> >>
> >> :-)
> >
> > Well, 3.11 is a week away and the 3.12 merge window will open then.
> >
> > Honestly, I'd prefer this stuff to spend a couple of weeks in
> > linux-next before pushing it to Linus, so this means 3.13 I'm
> > afraid.
> 
> +1

Ok. I understand. 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
