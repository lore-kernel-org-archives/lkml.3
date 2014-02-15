Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaBOUdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:33:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:48782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaBOUdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:33:31 -0500
Message-ID: <1392496342.10050.28.camel@pasglop>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sun, 16 Feb 2014 07:32:22 +1100
In-Reply-To: <1392487922.9366.15.camel@i7.infradead.org>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140215094239.GF14089@laptop.programming.kicks-ass.net>
	 <1392458479.10050.26.camel@pasglop>
	 <20140215154502.GK14089@laptop.programming.kicks-ass.net>
	 <1392487922.9366.15.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 18:12 +0000, David Woodhouse wrote:
> On Sat, 2014-02-15 at 16:45 +0100, Peter Zijlstra wrote:
> > 
> > David; in particular; quilt mail adds "Content-Disposition: inline"
> > headers and Evo, in its infinite wisdom, makes the entire body into an
> > attachment.
> 
> Hm, looking at the original email I see it as an inline part, displayed
> by default. I can read it, select parts of it and hit 'reply' to cite
> only the selected part... everything I can do with a normal email.
> 
> Ben, what precisely is it that makes it hard to read and review? All I
> can see is a trivial cosmetic issue; it's a few pixels down and right
> from where it would normally be.
> 
> But even that looks like it should be considered a bug. Please file in
> GNOME bugzilla.

In my case it doesn't have an inline part. I only get an attachment,

I'll file it in gnome bz.

Cheers,
Ben.


