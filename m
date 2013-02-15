Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab3BOPGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:06:45 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56621 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3BOPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:06:44 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Mats Liljegren <mats.liljegren@enea.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
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
Date: Fri, 15 Feb 2013 07:06:39 -0800
In-Reply-To: <20130215140429.GA4322@enea.se> (Mats Liljegren's message of
	"Fri, 15 Feb 2013 15:04:29 +0100")
Message-ID: <878v6p7h1c.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mats Liljegren <mats.liljegren@enea.com> writes:

[...]

>> To give it a try, below is a quick patch to convert kernel_cpustat to
>> atomic64.  I only got as far as compile testing and basic boot testing
>> on a 32-bit ARM platform, but let me know if this is the right
>> direction.

[...]

> I had to do some changes to get it to compile. You can check my patch below
> and see whether I got it all wrong...

Your changes are fine, and there are sure to be a few more that I missed
for various config options (your are because of CGROUP_CPUACCT which I
didn't have enabled here.)  I'll do a more thorough patch when I hear
from Frederic if this is a direction he's OK with.

Thanks for the changes,

Kevin
