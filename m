Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3KHHbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:31:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3KHHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:31:30 -0500
Message-ID: <1383895880.4964.91.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 08 Nov 2013 08:31:20 +0100
In-Reply-To: <20131108032343.GA18245@linux.vnet.ibm.com>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <20131108032343.GA18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Ko+lVUM3x6ixhkGj/iKSrNgmRMciDvWd7va5phiWHy3
 AbjvCcoNnEv3bX4zAhj0z6rnyfUzwqOT76PVxwe8pIQ/n0AwJa
 r7QJXhoN9P5prb0thW1M2Jo/Cku6J64DAQghRPLO6iMK1UUQu0
 OPCBbJBuUhqG6V70tLzMrJzfvfOSez3+iOcw8wFnouLLCXxrvI
 L7pxjbtnDY+oHPWATyL5jJbfS0aVoMxc+TgMRkP74SAfXAyzmX
 S0z9usbfGRkQZhwmh7LESmhAK7AWK3yV53+Ft4BGmwzQq8cYy1
 uoRxm/izq1uphnwrlkr8YBf7WY2yQbpwkbvc9cEXldaEvBMQYu
 1hxFwBpJkLjtoxCtv0kHveF87u6w0TB8zZFiHLuxN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 19:23 -0800, Paul E. McKenney wrote:

> An untested patch that gets rid of the RCU_SOFTIRQs in this case is below.

Yup, toasted.

-Mike

