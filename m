Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab3HSK5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:57:34 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50419 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3HSK5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:57:32 -0400
Date: Mon, 19 Aug 2013 12:57:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 0/3] qrwlock: Introducing a queue read/write lock
 implementation
Message-ID: <20130819105727.GA32308@gmail.com>
References: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
 <520A811A.7080907@hp.com>
 <20130814102041.GG10849@gmail.com>
 <520BA109.1000501@hp.com>
 <20130814155751.GA17821@gmail.com>
 <520EAC07.5050106@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520EAC07.5050106@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> >Could be a CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1 
> >kernel?
> >
> >Thanks,
> >
> >	Ingo
> 
> My test system was a RHEL6.4 system. The 3.10 kernel 
> config file was based on the original RHEL6.4 config 
> file. So yes, the CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE 
> parameter was set.

Ok, good, so that's an expected panic.

Thanks,

	Ingo
