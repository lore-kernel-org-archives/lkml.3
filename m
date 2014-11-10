Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaKJHLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:11:40 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35228 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJHLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:11:39 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
	<alpine.DEB.2.11.1411012003390.5308@nanos>
	<alpine.DEB.2.11.1411011646280.7732@gentwo.org>
	<alpine.DEB.2.11.1411012313320.5308@nanos>
	<alpine.DEB.2.11.1411061057470.5591@gentwo.org>
Date: Mon, 10 Nov 2014 12:41:38 +0530
Message-ID: <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2014 22:54, Christoph Lameter <cl@linux.com> wrote:

> We did not need to housekeeper in the dynticks idle case. What is so
> different about dynticks busy?

We do have a running task here and so the stats are important..

> I may not have the complete picture of the timer tick processing in my
> mind these days (it has been a lots of years since I did any work there
> after all) but as far as my arguably simplistic reading of the code goes I
> do not see why a housekeeper would be needed there. The load is constant
> and known in the dynticks busy case as it is in the dynticks idle case.

I tried to initiate a thread on similar stuff, might be helpful:

https://lkml.org/lkml/2014/5/22/131
