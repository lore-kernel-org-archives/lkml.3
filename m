Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaFIDRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 23:17:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57491 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaFIDRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 23:17:07 -0400
Message-ID: <1402283822.5195.3.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rt/aio: fix rcu garbage collection might_sleep()
 splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2014 05:17:02 +0200
In-Reply-To: <5395172E.4010007@cn.fujitsu.com>
References: <1402216538.31630.7.camel@marge.simpson.net>
	 <5395172E.4010007@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 10:08 +0800, Lai Jiangshan wrote: 
> Hi, rt-people
> 
> I don't think it is the correct direction.

Yup, it's a band-aid, ergo RFC.

-Mike

