Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3D0FbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:31:10 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:38070 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755130Ab3D0FbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:31:09 -0400
Message-ID: <1367040666.12779.20.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@olivierlanglois.net>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 27 Apr 2013 01:31:06 -0400
In-Reply-To: <1367038943.12779.10.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367027476.7911.60.camel@Wailaba2>
	 <CAHGf_=q5W1brnzmsK0bN9s07RXsRUyRoYKN347kySQs_3g2_Lg@mail.gmail.com>
	 <1367038943.12779.10.camel@Wailaba2>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:olivierlanglois.net} {sentby:smtp auth 173.178.230.31 authed with olivier@olivierlanglois.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 
> I did vary HZ from 300 to 1000 HZ, I tried the 3 three different
> preemption models.
> 
> With all these combinations, I still have the problem.
> 
Actually, I may have observed more failure with 1000 HZ and
CONFIG_PREEMPT=y (low-latency desktop)

Also make sure that High resolution timers support is enabled
(CONFIG_HIGH_RES_TIMERS).



