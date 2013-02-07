Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab3BGTOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:14:51 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:17395 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030181Ab3BGTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:14:50 -0500
Date: Thu, 7 Feb 2013 19:14:48 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
In-Reply-To: <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
Message-ID: <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com> <1360205415.2621.60.camel@gandalf.local.home> <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com> <1360256447.2621.75.camel@gandalf.local.home>
 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013, Frederic Weisbecker wrote:

> Not with hrtick.

hrtick? Did we not already try that a couple of years back and it turned
out that the overhead of constantly reprogramming a timer via the PCI bus
was causing too much of a performance regression?
