Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab3BGTzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:55:45 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47676 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab3BGTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:55:44 -0500
Date: Thu, 7 Feb 2013 20:55:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20130207195539.GD25223@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
 <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
 <1360256447.2621.75.camel@gandalf.local.home>
 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
 <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 7 Feb 2013, Frederic Weisbecker wrote:
> 
> > Not with hrtick.
> 
> hrtick? Did we not already try that a couple of years back and 
> it turned out that the overhead of constantly reprogramming a 
> timer via the PCI bus was causing too much of a performance 
> regression?

No, it was simply buggy.

Thanks,

	Ingo
