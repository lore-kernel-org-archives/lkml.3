Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaEJEPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 00:15:09 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63226 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaEJEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 00:15:07 -0400
Message-ID: <1399695303.5146.21.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14.3-rt5
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 10 May 2014 06:15:03 +0200
In-Reply-To: <20140509181214.GK29014@linutronix.de>
References: <20140509181214.GK29014@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 20:12 +0200, Sebastian Andrzej Siewior wrote:

> Known issues:
> 
>       - bcache is disabled.
> 
>       - lazy preempt on x86_64 leads to a crash with some load.

That is only with NO_HZ_FUL enabled here.  Box blows the stack during
task exit, eyeballing hasn't spotted the why.

> - CPU hotplug works in general. Steven's test script however
>         deadlocks usually on the second invocation.

My 64 core box runs for up to 14 hours, and never deadlocks.. it
explodes in what looks like it should be an impossible manner instead.

-Mike

