Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaJIDhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:37:16 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57245 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaJIDhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <20141009000123.4379.20957@quantum>
References: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
	<1412754534-14068-1-git-send-email-mturquette@linaro.org>
	<CAKohpo=9XG7XiLxBf=yo7=QCruawYxqPctC6kqB+syERFCoT6Q@mail.gmail.com>
	<20141008101115.1835927a@free-electrons.com>
	<CAKohpo=7VxrgdK9zPP89Px3aTiGhFihJ3uetC680fONDgE6O8Q@mail.gmail.com>
	<20141009000123.4379.20957@quantum>
Date: Thu, 9 Oct 2014 09:07:11 +0530
Message-ID: <CAKohpomPfq7nZ6MKGHmKcQUy4GP7VfODsvrZW16CKjYz+M2h6w@mail.gmail.com>
Subject: Re: [PATCH 0/2] allow cpufreq drivers to export flags
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        "pramod.gurav@smartplayin.com" <pramod.gurav@smartplayin.com>,
        Rob Herring <rob.herring@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 05:31, Mike Turquette <mturquette@linaro.org> wrote:
> Whether you merge the patches now or later is fine by me. I prefer to
> get my patches out early and often so I can avoid any surprises later
> on. If you have a fundamental objection to these patches then please let
> me know. Otherwise it would be wonderful to have an Ack.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

But I would still ask you to get these merged with scheduler changes. :)
