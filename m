Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3GQHRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:17:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57296 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3GQHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:17:20 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-01-51e644f99ad3
Date: Wed, 17 Jul 2013 09:17:06 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 6/7] cpufreq:boost:Kconfig: Enable software managed
 BOOST support at Kconfig
Message-id: <20130717091706.69b77c2f@amdc308.digital.local>
In-reply-to: <CAKohpo=XbUtYBVQ_y4_R18wpag_HAVvXrxfSfmaNSqq=wLpciQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-7-git-send-email-l.majewski@samsung.com>
 <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
 <20130716135022.64a102f8@amdc308.digital.local>
 <CAKohpo=XbUtYBVQ_y4_R18wpag_HAVvXrxfSfmaNSqq=wLpciQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgO5Pl2eBBpPvGlv8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBkL7n9lKvjFX3F5fQdLA+M+ni5GTg4JAROJjtVnmSFsMYkL99azdTFycQgJLGKUWNZ1jQnC
	aWeSWPKnjwWkikVAVWLHycVgHWwCehKf7z4FKuLgEBHQknh5MxWknlngI7PE3YO3weqFBVIl
	Plz/xgpi8wpYS5zZ8wkszikQLLHn/lWoBX+ZJCb8nA+W4BeQlGj/9wPqJDuJc582sEM0C0r8
	mHwPrIYZaNnmbU2sELa8xOY1b5knMArOQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEx9Iz6R2MqxosDjEKcDAq8fBOCHsaKMSaWFZcmXuIUYKDWUmEt1rjWaAQb0pi
	ZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRmbXiW9UMvT9PNM5
	ynI+64RU7l6aIpsWsbbPZuZGtZinPA8YWb2sWnmEy9v79m3T+i/4YfaqfRzXt5ana0jJNyX+
	+2uUb+lT2eqSlKn+6GDKq++n9T9nt7m4Jy5wmaUWKLV7cULdvJRPJiW/eM8ur1Pk+7MkXeac
	oeWjuomCF/U7dvn3/HypxFKckWioxVxUnAgAO9PqFqECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 10:54:55 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 16 July 2013 17:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Tue, 16 Jul 2013 15:28:40 +0530 Viresh Kumar
> > viresh.kumar@linaro.org wrote,
> >> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> > diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> >>
> >> > +config CPU_FREQ_BOOST_SW
> >> > +       bool "CPU frequency overclocking (BOOST)"
> >>
> >> Name it "CPU Frequency Overclocking - Software"
> >
> > Thanks, I had a puzzle to came up with a good short name :-).
> >
> >>
> >> > +       depends on ARM_EXYNOS_CPUFREQ && EXYNOS_THERMAL
> >                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> >>
> >> Remote Exynos from here. If you want to enable it for your
> >> platform by default, then select it from EXYNOS.

I can change ARM_EXYNOS_CPUFREQ -> CPUFREQ at [*]

> 
> I misread it a bit. I wanted to say make it dependent only on THERMAL
> and not on Exynos.

The cpufreq boost feature is possible to be enabled only when those [*]
dependencies are met. Moreover, it is disabled by default. 

This means that not only THERMAL generic code must be supported, but
also EXYNOS specific one - like per SoC trip points [**].

With thermal it is possible (and correct) to only define THERMAL, with
no platform (in this case Exynos) specific definitions. To force
potential user to define [**], I think, that EXYNOS_THERMAL is required.

> 
> > The purpose of the condition [*] here is to prevent from enabling
> > boost when thermal for Exynos is not supported.
> 
> Why? Can't others use it? Its not exynos specific :)

No it is not exynos specific.
For other platform one need to define:

depends on CPUFREQ && (EXYNOS_THERMAL || <PLATFORM_SUPPORTED>_THERMAL)

Such condition improves my confidence about proper boost usage.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
