Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3GQIN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:13:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57910 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3GQINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:13:23 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-0a-51e652213188
Date: Wed, 17 Jul 2013 10:12:51 +0200
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
Message-id: <20130717101251.164fbad8@amdc308.digital.local>
In-reply-to: <CAKohpona8E-JgLxyLnc_QuS9LAuJ7FBbsSGPZawQtOd8kRd4JA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-7-git-send-email-l.majewski@samsung.com>
 <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
 <20130716135022.64a102f8@amdc308.digital.local>
 <CAKohpo=XbUtYBVQ_y4_R18wpag_HAVvXrxfSfmaNSqq=wLpciQ@mail.gmail.com>
 <20130717091706.69b77c2f@amdc308.digital.local>
 <CAKohpona8E-JgLxyLnc_QuS9LAuJ7FBbsSGPZawQtOd8kRd4JA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgK5i0LNAgw0z+Cz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	rozXv7wKfotW3O5sZ29g/CrQxcjJISFgIrHg5Q1mCFtM4sK99WwgtpDAIkaJj29kuxi5gOx2
	JonlLc9ZQRIsAqoS83qbwYrYBPQkPt99ytTFyMEhIqAl8fJmKkg9s8BHZom7B2+zgNQIC6RK
	fLj+DayXV8BaYsbbG6wg9ZwCwRKfH9dCzP/GLDGr7yXYTH4BSYn2fz+gDrKTOPdpAztEr6DE
	j8n3wGYyA+3avK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4Ch6JrWDcWWDxSFGAQ5GJR7eCWFPA4VYE8uKK3MPMUpwMCuJ8FZrPAsU4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDhN5tEFk8O7V5uo
	xCjFL3l1Kie18/8X65ZPT1UnW7RIWHgfeXj3+LnNlxMDbi9rlbypkbAicLk574XbZ9prjs37
	93qZ1nWJe475dbcM1oZ/nK0e2/ePYbmFdoVM19F0QYNvrL73/iZExLbkz7/Oe0212MRr5flg
	Q/YJhjwih1ONdaalOD+7cU+JpTgj0VCLuag4EQAUZvHhngIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 13:22:20 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 17 July 2013 12:47, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Wed, 17 Jul 2013 10:54:55 +0530 Viresh Kumar
> > viresh.kumar@linaro.org wrote,
> >> On 16 July 2013 17:20, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> > On Tue, 16 Jul 2013 15:28:40 +0530 Viresh Kumar
> >> > viresh.kumar@linaro.org wrote,
> >> >> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com>
> >> >> wrote:
> >> >> > diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> >> >>
> >> >> > +config CPU_FREQ_BOOST_SW
> >> >> > +       bool "CPU frequency overclocking (BOOST)"
> >> >>
> >> >> Name it "CPU Frequency Overclocking - Software"
> >> >
> >> > Thanks, I had a puzzle to came up with a good short name :-).
> >> >
> >> >>
> >> >> > +       depends on ARM_EXYNOS_CPUFREQ && EXYNOS_THERMAL
> >> >                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> >> >>
> >> >> Remote Exynos from here. If you want to enable it for your
> >> >> platform by default, then select it from EXYNOS.
> >
> > I can change ARM_EXYNOS_CPUFREQ -> CPUFREQ at [*]
> 
> We are in cpufreq Kconfig and so dependency is automatically
> there on cpufreq.

So then, it can be removed.

> 
> >>
> >> I misread it a bit. I wanted to say make it dependent only on
> >> THERMAL and not on Exynos.
> >
> > The cpufreq boost feature is possible to be enabled only when those
> > [*] dependencies are met. Moreover, it is disabled by default.
> >
> > This means that not only THERMAL generic code must be supported, but
> > also EXYNOS specific one - like per SoC trip points [**].
> >
> > With thermal it is possible (and correct) to only define THERMAL,
> > with no platform (in this case Exynos) specific definitions. To
> > force potential user to define [**], I think, that EXYNOS_THERMAL
> > is required.
> >
> >>
> >> > The purpose of the condition [*] here is to prevent from enabling
> >> > boost when thermal for Exynos is not supported.
> >>
> >> Why? Can't others use it? Its not exynos specific :)
> >
> > No it is not exynos specific.
> > For other platform one need to define:
> >
> > depends on CPUFREQ && (EXYNOS_THERMAL ||
> > <PLATFORM_SUPPORTED>_THERMAL)
> 
> Exactly. I don't want this kind of mess to be present here.
> 
> People selecting this feature must know what it does and
> dependency on a coolant is enough.
> 
> For other drivers, selecting this doesn't matter as they don't
> support boost.

Then it should be enough to only write:

depends on THERMAL

(since CPUFREQ is already enabled for entering this menu).




-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
