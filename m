Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953Ab3DFNeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:34:36 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:46260 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422919Ab3DFNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:34:34 -0400
Message-ID: <51602459.3040105@synopsys.com>
Date: Sat, 6 Apr 2013 19:04:17 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
References: <alpine.LFD.2.02.1304031433350.21884@ionos> <1364998282-21437-1-git-send-email-vgupta@synopsys.com> <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
In-Reply-To: <515E54BD.2090300@synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/05/2013 10:06 AM, Vineet Gupta wrote:
> Hi Thomas,
> 
> Given that we are closing on 3.9 release, and that one/more of these patches fix a
> real issue for us - can you please consider my earlier patch to fix
> timer_pending() only for 3.9 [http://www.spinics.net/lists/kernel/msg1508224.html]
> This will be a localized / low risk change for this late in cycle.
> 
> For 3.10 - assuming preempt_* change is blessed, we can revert this one and add
> that fuller/better fix.
> 
> What do you think ?
> 
> Thx,
> -Vineet
> 

Ping ! Sorry for pestering, but one of the fixes is needed before 3.9 goes out.

Simple localized fix: http://www.spinics.net/lists/kernel/msg1508224.html
Better but risky: http://www.spinics.net/lists/kernel/msg1510885.html

Thx,
-Vineet
