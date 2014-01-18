Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaARDaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:30:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaARDaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:30:52 -0500
Message-ID: <1390015844.5444.50.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 18 Jan 2014 04:30:44 +0100
In-Reply-To: <20140117172319.GH5785@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
	 <1388052212.5420.4.camel@marge.simpson.net>
	 <20140117172319.GH5785@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Bk0Z5UMW7UGoSt9pzxW67sydT7VJiKtHPNdzcC88cOS
 9bBJsvJMtWhv9uQWvMnWQvACh3RKbnbX4UcDdifluBznInyMyT
 MyaNB6FxmXwy4REARUG37ipk+D2fcENIGqmkcGT5QG2MK78CtG
 8z1dPDWPX5Zjq0+Rl6wlxZpIS2RoG5boulZIkmRpFZNoJfbaX+
 IjdH1ph2B1De5u8uo6V+1VSKE2/JWtOM0Go8ZDdnCPPfhFTm9L
 /fhKuJ1zcill6Z8Sho9oqS8bqUnJct55MbM1UHioonbIOZvb+8
 J9315og0HPK/ZMb6XhOki/AHWk++NQUD1NVKjRxTHjB8SOhEko
 ckgJg/X+vU+yRwxDoZEqRgWP2N0dDcq9Yru5MlytmmVrPv9Gpu
 ckMQZBLxf1rtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 18:23 +0100, Sebastian Andrzej Siewior wrote:

> So I had rtmutex-take-the-waiter-lock-with-irqs-off.patch in my queue
> which took the waiter lock with irqs off. This should be the same thing
> you try do here.

(yeah, these are just whacked mole body bags;)

