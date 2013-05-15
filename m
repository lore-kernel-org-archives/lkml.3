Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3EOREG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:04:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541Ab3EOREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:04:04 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3aLxPhj7Q5gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=e7SmI9TJ9RsA:10 a=l8LECa6oiMWHDP9V_YAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368637441.6828.70.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 15 May 2013 13:04:01 -0400
In-Reply-To: <20130515165915.GE13916@laptop.home>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
	 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
	 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
	 <20130515150652.GP23604@redhat.com>
	 <1368631622.6828.69.camel@gandalf.local.home>
	 <20130515165915.GE13916@laptop.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 18:59 +0200, Peter Zijlstra wrote:

> At which point we could run the watchdog without perf_event_task_tick().

At which point we can drop the disable LOCKUP_DETECTOR when NO_HZ_FULL
is enabled ;-)

-- Steve


