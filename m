Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3FZMRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:17:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54587 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3FZMRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:17:38 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-c4-51cadbd68fdc
Date: Wed, 26 Jun 2013 14:17:20 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Message-id: <20130626141720.24f6bcb0@amdc308.digital.local>
In-reply-to: <CAKohpom2h3R4=B9e8ZvqEUmudB19-cnv3Lgp0=BkxgYdGA6CUA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-4-git-send-email-l.majewski@samsung.com>
 <CAKohpom2h3R4=B9e8ZvqEUmudB19-cnv3Lgp0=BkxgYdGA6CUA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAd3rt08FGqy4xWzx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbXF51xw2i8+9RxgtbjeuYLPoX9jLZPHkYR+bRceR
	b8wWG796OPB5LN7zksnjzrU9bB7rpr1l9ujbsorR49HiFkaP4ze2M3l83iQXwB7FZZOSmpNZ
	llqkb5fAlbGhQ7LgJGvF03f9LA2Mu1m6GDk5JARMJN6fbGSCsMUkLtxbz9bFyMUhJLCIUWLl
	qa8sEE47k8TyzjeMXYwcHCwCqhJf9ruDNLAJ6El8vvuUCSQsIqAl8fJmKkg5s8B2FolLTbPY
	QGqEBQol5q9tYQSxeQWsJY48280MUs8pECxxfLE/xPgWJokL03azg9TwC0hKtP/7wQxxkJ3E
	uU8b2CF6BSV+TL4HdjQz0K7N25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjqdn0jsYVzVYHGIU4GBU4uFV2HoyUIg1say4MvcQowQHs5II
	75v5pwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MNaG
	X3lwM26ny31jtn53L45rL607TGd5nU33XmkqIrW16K9a1Gup+bUBf46meEWs31v+4FHddd0X
	E3ZlpiUeXev/ZB2r/3Sz58lfXn6b+uaM/q5VVrU5lQ+8tl5ee5jB6lxM3ZF50tniwp6/jWZf
	/rfkOpuB8YtcCWPBmI3B+5iTbz7d9MDTPk+JpTgj0VCLuag4EQAAoTsqowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:33:30 +0530, Viresh Kumar wrote:
> On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/acpi-cpufreq.c
> > b/drivers/cpufreq/acpi-cpufreq.c
> 
> >  static unsigned int acpi_pstate_strict;
> > -static bool boost_enabled, boost_supported;
> > +static bool boost_enabled;
> 
> Instead of this variable use cpufreq_boost_enabled() directly.

OK.

> 
> And then this patch may change as well..
> 
> I couldn't find any more issues with this patch but some Intel guy
> must review it.

Yes, indeed Intel review is welcome.
-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
