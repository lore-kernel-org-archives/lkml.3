Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab3KMQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:31:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63284 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756884Ab3KMQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:31:50 -0500
Date: Wed, 13 Nov 2013 11:31:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113113148.6c24e782@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1311131717300.30673@ionos.tec.linutronix.de>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311131717300.30673@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 17:21:53 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

 
> Frozen shark time ....

As long as it's not aimed at me ;-)

-- Steve

