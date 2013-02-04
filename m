Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3BDUZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:25:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40658 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3BDUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:25:53 -0500
Date: Mon, 4 Feb 2013 12:25:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130204202523.GZ2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <20130204180734.GA10022@gmail.com>
 <20130204193041.GA16853@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204193041.GA16853@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020420-5806-0000-0000-00001F23E089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:30:41PM +0100, Ingo Molnar wrote:
> 
> Btw., I'm now getting these build errors in -tip too:
> 
>  kernel/built-in.o: In function `rcu_torture_reader':
>  rcutorture.c:(.text+0x657d7): undefined reference to `trace_clock_local'
>  kernel/built-in.o: In function `rcu_torture_timer':
>  rcutorture.c:(.text+0x6599f): undefined reference to `trace_clock_local'
> 
> Saw the discussion about so I suspect a fix will come?

<red face>

I have a new rcu/next with the fix, and I will post a pull for it assuming
that -next does OK with it.

							Thanx, Paul

