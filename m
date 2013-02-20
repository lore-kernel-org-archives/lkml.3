Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254Ab3BTRxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:53:36 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48284 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3BTRxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:53:34 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<87k3qa7333.fsf@linaro.org> <20130215140429.GA4322@enea.se>
	<CAFTL4hyku_zDWe0DzcBHtd098GjCzncuQ7WoDx1Amt3_Ey551g@mail.gmail.com>
Date: Wed, 20 Feb 2013 09:53:30 -0800
In-Reply-To: <CAFTL4hyku_zDWe0DzcBHtd098GjCzncuQ7WoDx1Amt3_Ey551g@mail.gmail.com>
	(Frederic Weisbecker's message of "Wed, 20 Feb 2013 16:53:25 +0100")
Message-ID: <87mwuyrhwl.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> 2013/2/15 Mats Liljegren <mats.liljegren@enea.com>:
>> Kevin Hilman wrote:
>> /Mats
>>
>> From e3da56bdb36a3efb5a9869ded20f346039f381f2 Mon Sep 17 00:00:00 2001
>> From: Mats Liljegren <mats.liljegren@enea.com>
>> Date: Fri, 15 Feb 2013 13:46:29 +0100
>> Subject: [PATCH] Added atomic operators to make it compile
>
> Could you please fold this into the previous patch and resend it in a
> new thread so we can start a fresh review discussion?

Yes, I have an RFC series coming shortly.

Kevin


