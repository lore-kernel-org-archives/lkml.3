Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3DLOXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:23:37 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39557 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3DLOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130410172446.GF21951@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
	<20130408111919.GB1225@gmail.com>
	<CAFTL4hxDGfEWPz0+zsHLmdaPDSg4n0iFHpeN=w=5eFGX9sRZ2w@mail.gmail.com>
	<20130410172446.GF21951@gmail.com>
Date: Fri, 12 Apr 2013 16:23:35 +0200
Message-ID: <CAFTL4hw26x4Z4_z3dn+Cgd5Ufy1vD2To1R4xfTDfS7+45kVx+A@mail.gmail.com>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
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
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/10 Ingo Molnar <mingo@kernel.org>:
>> Agreed. I mentioned that in the pull request. It's again due to an
>> arbitrary Kconfig limitation. The following:
>>
>>     config X
>>         select Y
>>
>> doesn't work if Y is part of a Kconfig "choice".
>> I have a patch that fixes in Kconfig, will submit it to Michal and fix
>> the nohz passive dependency once we get that sorted.
>
> Wow, you are fixing kconfig.
>
> 99% of the people work it around in some fashion.
>
> Kudos!

Wait, I'm actually _trying_ to! I found a few bugs in my patch
already. Looks like it's not going to be a piece of cake.
