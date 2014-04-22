Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaDVKc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:32:56 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63559 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaDVKcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com>
Date: Tue, 22 Apr 2014 16:02:52 +0530
X-Google-Sender-Auth: 673qHlFk-Wj0IcXi0KBNuFd_Npc
Message-ID: <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
Subject: Re: vmstat: On demand vmstat workers V3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 11:10 PM, Christoph Lameter <cl@linux.com> wrote:
> V2->V3:
> - Introduce a new tick_get_housekeeping_cpu() function. Not sure
>   if that is exactly what we want but it is a start. Thomas?
> - Migrate the shepherd task if the output of
>   tick_get_housekeeping_cpu() changes.
> - Fixes recommended by Andrew.

Hi Christoph,

This vmstat interrupt is disturbing my core isolation :), have you got
any far with this patchset?

--
viresh
