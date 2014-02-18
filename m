Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaBRHit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:38:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36458 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBRHis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:38:48 -0500
Date: Tue, 18 Feb 2014 08:38:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
Message-ID: <20140218073825.GY27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <53029167.4060109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53029167.4060109@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:47:03PM -0800, H. Peter Anvin wrote:
> This is starting to look good, so I have pulled it into
> tip:x86/spinlocks to start give it some testing mileage.

Its still atrociously ugly code please drop it.
