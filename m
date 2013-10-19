Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3JSV6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:58:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48517 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751198Ab3JSV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:58:49 -0400
Date: Sat, 19 Oct 2013 17:58:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Petr Mladek <pmladek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Message-ID: <20131019175845.26eb9314@gandalf.local.home>
In-Reply-To: <20131019213350.GH4118@linux.vnet.ibm.com>
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
	<52629F08.2010609@hitachi.com>
	<20131019151658.583ac18e@gandalf.local.home>
	<20131019151919.2d4778d2@gandalf.local.home>
	<20131019213350.GH4118@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013 14:33:50 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> > 	/* Ideally we would like to run on zero CPUS! */
> > 	if (num_online_cpus() < 2)
> 
> To be really safe, shouldn't you use complex numbers?  Just in case
> you end up running on a system with 5i-3 CPUs or something.  ;-)
> 
> 							Thanx, Paul

I did think about that, but I didn't know the algorithm to test such a
case, which is why I added you to the Cc. Hoping you would come up with
a better conditional.

-- Steve

