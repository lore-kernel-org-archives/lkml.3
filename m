Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3JJNkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:40:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab3JJNka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:40:30 -0400
Date: Thu, 10 Oct 2013 15:40:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, hpa@linux.intel.com, williams@redhat.com,
        akpm@linux-foundation.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131010134024.GC9929@pd.tnic>
References: <20131009144150.108f7041@gandalf.local.home>
 <20131010001153.1f171bff@gandalf.local.home>
 <20131010.001939.1669180620160012783.davem@davemloft.net>
 <20131010090300.GB9929@pd.tnic>
 <20131010083047.6fb34a12@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131010083047.6fb34a12@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:30:47AM -0400, Steven Rostedt wrote:
> I just looked at my Address book, and sure enough, when you save an
> email with quotes, Claws will strip them when adding it to the address
> book. If you use the address book to send email, then it will use it
> without quotes. This can explain why Paul wasn't getting a lot of my
> emails too :-/

But why does it have quotes in the CC list of the copy I have in my
mbox?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
