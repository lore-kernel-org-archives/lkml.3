Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaEED0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:26:52 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42818 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaEED0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:26:50 -0400
Message-ID: <1399260407.5172.41.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14.2-rt3
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Mon, 05 May 2014 05:26:47 +0200
In-Reply-To: <20140503170110.GA10652@linutronix.de>
References: <20140503170110.GA10652@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-03 at 19:01 +0200, Sebastian Andrzej Siewior wrote:

> - Mike Galbraith sent a patch which might fix lazy preempt on x86_64.
>   Patch applied and my machine still explodes therefore lazy preempt
>   remains off on x86_64.

Can you send me your config offline?  I'll try to scrape up some cycles
to take another peek.  It seems to work fine on my boxen, so there must
be a config dependent bug somewhere.

> - Mike Galbraith sent a few patches to get cpu hoplug to work. This
>   includes lg_global_trylock_relax().

(applies frozen shark repellent.. liberally)

-Mike

