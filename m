Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab3BGPlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:41:47 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:43935 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653Ab3BGPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:41:45 -0500
Date: Thu, 7 Feb 2013 15:41:44 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
In-Reply-To: <20130207111025.GD8945@gmail.com>
Message-ID: <0000013cb551d26c-19d33303-91e1-4bb6-a741-ae01bf80cc5c-000000@email.amazonses.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com> <1360205415.2621.60.camel@gandalf.local.home> <20130207111025.GD8945@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013, Ingo Molnar wrote:

> Agreed?

Yes and please also change the texts in Kconfig to accurately describe
what happens to the timer tick.
