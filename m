Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3GSLZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:25:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:49154 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GSLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:25:10 -0400
Date: Fri, 19 Jul 2013 13:25:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: mod_timer: list_add corruption: WARNING: CPU: 1 PID: 0 at
 lib/list_debug.c:33 __list_add+0xbe/0xd0()
In-Reply-To: <51E557C0.2060602@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1307191323150.4089@ionos.tec.linutronix.de>
References: <51E557C0.2060602@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Srivatsa S. Bhat wrote:
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
> list_add corruption. prev->next should be next (ffff8810396b5568), but was           (null). (prev=ffff88102c1344c0).

Can you please enable debugobjects?

Thanks,

	tglx
