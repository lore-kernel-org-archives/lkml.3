Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaEEO0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:26:02 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44033 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbaEEOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomeP3Ftx8mH=x0Hj7HEpw6A9X8O8JEFqvrJbkZYDqDS6Q@mail.gmail.com>
References: <1399296830-13056-1-git-send-email-nm@ti.com>
	<1399296830-13056-2-git-send-email-nm@ti.com>
	<CAKohpomeP3Ftx8mH=x0Hj7HEpw6A9X8O8JEFqvrJbkZYDqDS6Q@mail.gmail.com>
Date: Mon, 5 May 2014 09:25:58 -0500
X-Google-Sender-Auth: xIMLTdmq3G2zWt2BS92KATIuzvg
Message-ID: <CAGo_u6pcEKDiAqvJW66_p7M7D0noFj6o9Rw5_d8Af3NMBhHA=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM / OPP: Remove cpufreq wrapper dependency on
 internal data organization
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 9:23 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
>
> What if opp is being added for some reason at the same time?
> I hope we can surely see some awkward results, maybe some
> NULL pointers invocations as well..

we wont - rcu operations ensure that.
