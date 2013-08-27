Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3H0ItN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:13 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45514 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3H0ItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130827104512.7d04d379@amdc308.digital.local>
References: <CAKohpom90VAMYHkp3stbJJ-7H3y3zrVoQ+1q=Vza2Q0JhG8bNw@mail.gmail.com>
	<20130827104512.7d04d379@amdc308.digital.local>
Date: Tue, 27 Aug 2013 14:19:06 +0530
Message-ID: <CAKohpo=XOUPfiyVbR5eERxHrnw04M68wba9y6iJ=RrVdutN0Gw@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] cpufreq:boost: CPU Boost mode support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 14:15, Lukasz Majewski <l.majewski@samsung.com> wrote:
> For my future work it is important, to "stabilize" those patches at
> some kernel_pm branch (linux-next or other).

You can rebase them over 3.12-rc1 as soon as it is released after few
weeks and then Rafael can get them into linux-next.
