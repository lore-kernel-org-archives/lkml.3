Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3A2Cog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:44:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3A2Cod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:44:33 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=6m4_6qrbAAAA:8 a=Dr9ry12dXNxPa_L_gtAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359427458.17639.12.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Date: Mon, 28 Jan 2013 21:44:18 -0500
In-Reply-To: <CAFTL4hwbbLoPYwvyEUYyn2EuEj=2nw2NPehe8G4rykRTE3LziA@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	 <1359417749.17639.6.camel@gandalf.local.home>
	 <1359426979.17639.10.camel@gandalf.local.home>
	 <CAFTL4hwbbLoPYwvyEUYyn2EuEj=2nw2NPehe8G4rykRTE3LziA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 03:39 +0100, Frederic Weisbecker wrote:

> Please send me your kernelspin so I can test as well.

http://rostedt.homelinux.com/private/kernelspin.c

http://rostedt.homelinux.com/private/userspin.c

-- Steve


