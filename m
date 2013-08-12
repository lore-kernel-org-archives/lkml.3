Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3HLK0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:26:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65461 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3HLK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:26:48 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-49-5208b8661f10
Date: Mon, 12 Aug 2013 12:26:14 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 5/8] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Message-id: <20130812122614.0d4d31a3@amdc308.digital.local>
In-reply-to: <CAKohponvOXuHSS+-+m5PR9tPkAqkrYtjA3FJaNh9NJXrhQ9wmw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-6-git-send-email-l.majewski@samsung.com>
 <CAKohpokL57mXSQooX=4LZKtjMxJoXAB4uuzj13fgr3Gs7Wcf0A@mail.gmail.com>
 <20130726132120.5b9cf32f@amdc308.digital.local>
 <CAKohponvOXuHSS+-+m5PR9tPkAqkrYtjA3FJaNh9NJXrhQ9wmw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoG7aDo4gg3kXhS02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	roz3vUIFW4UqZk6Jb2A8xNfFyMkhIWAi8eHpPEYIW0ziwr31bF2MXBxCAtMZJd6+WswKkhAS
	aGeSeLuIBcRmEVCVeHfxHDuIzSagJ/H57lOmLkYODhEBLYmXN1NBepkF/jJL9D1qYAOpERaI
	l2hsOgBm8wpYS2zY+QXM5hQIlli7cgIrxLL/TBINbR/AlvELSEq0//vBDHGRncS5TxvYIZoF
	JX5Mvgd2BDPQss3bmlghbHmJzWveMk9gFJyFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAiOomdSOxhXNlgcYhTgYFTi4fX4wh4kxJpYVlyZe4hRgoNZSYRXbR5HkBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGrRsCdX688lFw
	rWPuv2DFIMq0vPid5uTMyi+vLGz6vmzUym5tkM27yMb89c+NLRsbN/9/p3xN1Zj5F3txKdcM
	xZ45wYuEUmUj29/1CL+YKq7WEr086tm+m78YrOts3/JFHVw4XbsxeOM6u6ubrDf7bDurEb42
	0v2YJKfCidwq64fKP9aXh7xSYinOSDTUYi4qTgQAqeCBgJ4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 12:28:02 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 July 2013 16:51, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Fri, 26 Jul 2013 15:54:56 +0530 Viresh Kumar wrote,
> >> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> > +config CPU_FREQ_BOOST_SW
> >> > +       bool
> >>
> >> Invisible is fine but this must be disabled by default and must
> >> depend on thermal, rather than moving dependency on platform's
> >> config.
> >
> > The CPU_FREQ_BOOST_SW [1] is a generic flag (invisible).
> >
> > I will add "default n" to it.
> 
> Leave it.. We don't need it now.. that's how these kind of config
> options are defined as they are disabled by default.

Ok. Please see below proposition.

> 
> > Depending only on [3], results at situation where SW BOOST can be
> > enabled at x86 or ARM target with only generic THERMAL support
> > (which doesn't protect from overheating).
> 
> I had a similar concern.. Currently also we aren't stopping anybody to
> enable boost. By selecting thermal from CPU_FREQ_BOOST_SW, atleast
> we are communicating this very well to developers that they need
> something else as well. And currently we only have thermal as a source
> for telling when to block boost but it can be something else too..
> 
> I never said, don't use EXYNOS_THERMAL, its good to have a
> dependency on it in the Exynos specific config for boost, but I wanted
> normal sw boost also to depend on thermal..

1. at ./drivers/cpufreq/Kconfig:

+config CPU_FREQ_BOOST_SW
+	bool
+	depends on THERMAL

2. at ./drivers/cpufreq/Kconfig.arm:

+config ARM_EXYNOS_CPU_FREQ_BOOST_SW
+	bool "EXYNOS Frequency Overclocking - Software"
+	depends on ARM_EXYNOS_CPUFREQ
+	select CPU_FREQ_BOOST_SW
+	select EXYNOS_THERMAL
+	default n
+	help
+	  This driver supports software managed overclocking (BOOST).
+	  It allows usage of special frequencies for Samsung Exynos
+	  processors if thermal conditions are appropriate.
+
+	  It reguires, for safe operation, thermal framework with
  properly
+	  defined trip points.
+
+	  If in doubt, say N.
+

Shall I split this patch to two (1. and 2.) or leave it as a single one?

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
