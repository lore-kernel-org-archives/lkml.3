Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaBOUxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:53:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:48941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbaBOUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:53:29 -0500
Message-ID: <1392497560.24061.1.camel@pasglop>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sun, 16 Feb 2014 07:52:40 +1100
In-Reply-To: <1392496342.10050.28.camel@pasglop>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140215094239.GF14089@laptop.programming.kicks-ass.net>
	 <1392458479.10050.26.camel@pasglop>
	 <20140215154502.GK14089@laptop.programming.kicks-ass.net>
	 <1392487922.9366.15.camel@i7.infradead.org>
	 <1392496342.10050.28.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2014-02-16 at 07:32 +1100, Benjamin Herrenschmidt wrote:

> > But even that looks like it should be considered a bug. Please file in
> > GNOME bugzilla.
> 
> In my case it doesn't have an inline part. I only get an attachment,
> 
> I'll file it in gnome bz.

Hah, story of my life: 3.8.x is marked "obsolete" in gnome BZ :)

I suppose that's the price for using Ubuntu, the version of evolution is
always just old enough that nobody cares about bugs in it anymore :-)

Anyway, gnome3 PPA gave me 3.10.3 and the problem is still there, filing
as https://bugzilla.gnome.org/show_bug.cgi?id=724437

Cheers,
Ben.


