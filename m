Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaBTSQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:16:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42110 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaBTSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:16:17 -0500
Date: Thu, 20 Feb 2014 19:15:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20140220181559.GL9987@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <53029167.4060109@zytor.com>
 <20140218073111.GW27965@twins.programming.kicks-ass.net>
 <5303B4C4.2040907@hp.com>
 <20140218212827.GR14089@laptop.programming.kicks-ass.net>
 <5303FDEC.9060001@hp.com>
 <20140219085107.GG27965@twins.programming.kicks-ass.net>
 <53050501.3070101@hp.com>
 <20140219194832.GY14089@laptop.programming.kicks-ass.net>
 <53063D4A.9010601@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53063D4A.9010601@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 12:37:14PM -0500, Waiman Long wrote:
> Yes, that is true for paravirt, but I was talking about virtualization in
> general.

Them we really don't care about :-)
