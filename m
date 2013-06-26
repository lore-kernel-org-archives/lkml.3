Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3FZMP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:15:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28426 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:15:57 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-08-51cadb7b7dfb
Date: Wed, 26 Jun 2013 14:15:48 +0200
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
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 1/7] cpufreq: Store cpufreq policies in a list
Message-id: <20130626141548.31cda5ed@amdc308.digital.local>
In-reply-to: <CAKohpo=aaJyhZ1U2W=DUyi8wGH=rLCL47SBSO7TgsxHXamdotA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-2-git-send-email-l.majewski@samsung.com>
 <CAKohpomStuSGyQHnk9jNLpije=SAkb4zHg40zHDgLRCUQeZC1A@mail.gmail.com>
 <20130626125411.5dc935bf@amdc308.digital.local>
 <CAKohpom1yJOAVZ1XE+Q+dtrZM1N6Zqd7DjURSA_f2fhQ1OiCJA@mail.gmail.com>
 <20130626130407.021c05cb@amdc308.digital.local>
 <CAKohpo=aaJyhZ1U2W=DUyi8wGH=rLCL47SBSO7TgsxHXamdotA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAd3q26cCDTZONbL483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitri8aw6bxefeI4wWtxtXsFn0L+xlsnjysI/NYv2M
	1ywWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxuRzdQXvmStm7d3G1sD4g6mLkZNDQsBEYuqzlywQtpjEhXvr2boYuTiE
	BBYxSsz6sIYdwmlnkvix5wlYFYuAqsSp7xPZQWw2AT2Jz3efAk3i4BAR0JJ4eTMVpJ5Z4DSL
	xI4H19hB4sICrhLXzyuClPMKWEvMudYO1sopECzx728fE8T8b8wSu88cZwZJ8AtISrT/+8EM
	cZGdxLlPG9ghmgUlfky+B3YDM9CuzduaWCFseYnNa94yT2AUnIWkbBaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECI6tZ1I7GFc2WBxiFOBgVOLhVdh6MlCINbGsuDL3EKME
	B7OSCO+b+acChXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBK
	NTCK7WEo/eUgcjXGQLXN6XpA+D+phJhTE7I9njXGn4w9NeHuqabi1lhnZxdObZ2yQ087prc/
	r5k0t6io3OBZa96pY+Yejm0VbKdqnpnH6/1Vdm2RZmBe0732xvzZP8QWXxKv57U5EbKL+feS
	tW/n2Nx/lHVpWSzjGcnXSxtv1/QtWyh47s/l891KLMUZiYZazEXFiQCrIaHgqQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:38:15 +0530, Viresh Kumar wrote:

> On 26 June 2013 16:34, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > err_out_kobj_put:
> >         list_del(&cpufreq_policy_list);
> >         [rest of error path]
> 
> I couldn't find err_out_kobj_put in existing code :)
> 
> BTW, just add to the list only once everything passed.

Ok, we can do it like that :-)

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
