Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916Ab3GSQi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:38:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:50758 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759717Ab3GSQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:38:55 -0400
Date: Fri, 19 Jul 2013 18:38:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Cong Wang <amwang@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        netdev@vger.kernel.org
Subject: Re: mod_timer: list_add corruption: WARNING: CPU: 1 PID: 0 at
 lib/list_debug.c:33 __list_add+0xbe/0xd0()
In-Reply-To: <1374241882.26476.5.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.02.1307191834460.4089@ionos.tec.linutronix.de>
References: <51E557C0.2060602@linux.vnet.ibm.com>  <alpine.DEB.2.02.1307191323150.4089@ionos.tec.linutronix.de>  <51E92769.7090106@linux.vnet.ibm.com>  <alpine.DEB.2.02.1307191523050.4089@ionos.tec.linutronix.de> <1374241882.26476.5.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Eric Dumazet wrote:
> 
> I guess following should help 

Applying the empty patch does not work very well. Could you try again
after the caffeine reached your brain, please ? :)

Thanks,

	tglx
