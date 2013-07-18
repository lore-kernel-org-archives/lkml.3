Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3GRHvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:51:44 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51816 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3GRHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130717165943.7f06acd9@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<6633375.dICiDrHJgK@vostro.rjw.lan>
	<CAKohpokw-bSWEgKvx0jd2QZ0RCz5dORHM9z+VYbTdKoCmKFvsg@mail.gmail.com>
	<2509113.ybUsa2l9tg@vostro.rjw.lan>
	<CAKohpo=1Qov8p3f2xZkfOqaFRNJPJN60KeK4SOXcL9Hw82MkAg@mail.gmail.com>
	<20130717165943.7f06acd9@amdc308.digital.local>
Date: Thu, 18 Jul 2013 13:21:41 +0530
Message-ID: <CAKohpo=fwxssYQiDoShMak5f=fuOTC4uFaXbW8vb0pE+j7JbUQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lukasz Majewski <l.majewski@majess.pl>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 20:29, Lukasz Majewski <l.majewski@samsung.com> wrote:
> To be 100% sure - we export boost only when supported (as proposed at v5).

Yes.
