Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3FLPTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:19:23 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63081 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3FLPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:19:21 -0400
Date: Wed, 12 Jun 2013 17:19:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Full dynticks selftests 0.0.1
Message-ID: <20130612151915.GD5332@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been using a homemade test for full dynticks all that time and I regret I haven't shared
it much sooner. I've been asked for such a tool many times and getting full dynticks working
correctly is often not a piece of cake.

Here it is, a very basic test that runs a userspace loop for ten seconds and dumps a trace
of the tick, scheduler, workqueue, and other kind of kernel noise.

You can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/dynticks-testing.git
	master

I hope it helps! Feel free to send any kind of improvements if you wish.

Thanks!
