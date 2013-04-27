Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3D0FGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:06:36 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53318 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752058Ab3D0FGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:06:36 -0400
Message-ID: <1367039190.12779.14.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 27 Apr 2013 01:06:30 -0400
In-Reply-To: <CAHGf_=q5W1brnzmsK0bN9s07RXsRUyRoYKN347kySQs_3g2_Lg@mail.gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367027476.7911.60.camel@Wailaba2>
	 <CAHGf_=q5W1brnzmsK0bN9s07RXsRUyRoYKN347kySQs_3g2_Lg@mail.gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2) tst-cputimer1.c only have CLOCK_PROCESS_CPUTIME_ID test and
> don't have any utime, stime tests.
> 
Sorry, I should take a couple minutes break before pressing send to be
sure that I have said everything :-)

CLOCK_PROCESS_CPUTIME_ID is user space name for kernel space
CPUCLOCK_SCHED clock.

and your are correct. It doesn't have any utime and stime test. Hence
this is why I am reticent to state anything about them when we discussed
about the relevence of update_gt_cputime() once we have the patch in.

Greetings,
Olivier


