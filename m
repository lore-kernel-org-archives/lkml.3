Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3BDTaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:30:52 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64428 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3BDTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:30:51 -0500
Date: Mon, 4 Feb 2013 20:30:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130204193041.GA16853@gmail.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <20130204180734.GA10022@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204180734.GA10022@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw., I'm now getting these build errors in -tip too:

 kernel/built-in.o: In function `rcu_torture_reader':
 rcutorture.c:(.text+0x657d7): undefined reference to `trace_clock_local'
 kernel/built-in.o: In function `rcu_torture_timer':
 rcutorture.c:(.text+0x6599f): undefined reference to `trace_clock_local'

Saw the discussion about so I suspect a fix will come?

Thanks,

	Ingo
