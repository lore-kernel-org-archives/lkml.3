Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3C1NMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:12:54 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59150 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3C1NMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130328074045.GB24433@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
	<1364398359-21990-3-git-send-email-fweisbec@gmail.com>
	<20130328074045.GB24433@gmail.com>
Date: Thu, 28 Mar 2013 14:12:49 +0100
Message-ID: <CAFTL4hy1cjZ+ty2qRphNqEuEwDmPZr9s7b9fSPwDWuBE8dto7w@mail.gmail.com>
Subject: Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> +     cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
>> +     pr_info("NO_HZ: Experimental full dynticks CPUs: %s.\n", nohz_ext_buf);
>
> I'd suggest removing the 'experimental' word. We are not sending anything
> experimental to Linus: we'll send something that is tested and that we
> expect to not break anything. (and which we'll fix if it does)

Ok. Just wanted to warn the user that feature is still young and
hasn't yet passed through many real world workloads. But the Kconfig
is probably enough for that.
