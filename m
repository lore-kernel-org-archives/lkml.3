Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3BHGSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:18:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3BHGSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:18:30 -0500
Message-ID: <1360304280.5781.2.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Mike Galbraith <bitbucket@online.de>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
Date: Fri, 08 Feb 2013 07:18:00 +0100
In-Reply-To: <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
	 <1360256447.2621.75.camel@gandalf.local.home>
	 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
	 <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:GQwLRw0ihM6thqMHc1fycK7qp++P9DARcT2PU4P3XKo
 CPTxv312Ct+a+hpNlIwHVGXxtXJsUCV4Pd8IVB+Pkpk1w3+Wi1
 S9lffnYqf+OfbB+fgUxCR+HHLspGgg+9Yb3ayuRsEGVn3m2KCk
 zKfpHM3xd5CWK0rGO6fg0jeaPKaOhm3Z7fQzzIN9uOub+WY88Y
 HBKOYIr4q4Xm6iEtPxH5LxqdP3u5YlLp+1D+mCICHI2wfgxqSJ
 pwyToT7ItOTYAI/DTYiRreaeZ/uJl90rkg1ex3tD6aPSRL0EDy
 zw6dHb6YAZSmXhic18Rk7yZ09r6mbyZzaPKmeGioEOryGjVOTu
 9LCbxDXJgqVjvuGgvjur6Jn36nM9jb3p8QsMUSD7SjAS8mz9PN
 nv/3uIbDIt5sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 19:14 +0000, Christoph Lameter wrote: 
> On Thu, 7 Feb 2013, Frederic Weisbecker wrote:
> 
> > Not with hrtick.
> 
> hrtick? Did we not already try that a couple of years back and it turned
> out that the overhead of constantly reprogramming a timer via the PCI bus
> was causing too much of a performance regression?

Yup.

-Mike

