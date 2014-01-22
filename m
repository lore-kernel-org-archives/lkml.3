Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaAVRg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:36:29 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52246 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaAVRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:36:27 -0500
Date: Wed, 22 Jan 2014 18:36:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: hpa@zytor.com, alan@linux.intel.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
Message-ID: <20140122173622.GA12023@gmail.com>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
 <1390325069.2472.78.camel@joe-AO722>
 <20140122122728.GA8882@gmail.com>
 <1390395744.31946.45.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390395744.31946.45.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Your main argument is that some people don't cc lkml
> because section entries don't specify it explicitly.

No, my main argument continues to be that having a 'at a glance' 
contact summary _in a single place_ is eminently useful to humans, 
because it's so simple:

>>    In hindsight removing all the "L: lkml" entries was probably not
>>    an overly good idea, not all mechanic duplication should be
>>    eliminated: in files read by humans it's useful to have 'at a
>>    glance' summary for all email addresses important to a subsystem's
>>    maintenance, in a single place, without too many imported rules
>>    and assumptions.

No amount of rules written elsewhere can counter that simple concept!

> My main argument, which you elided, is that some people
> will not cc lkml because they will see some sections
> with L: entries with lkml and others without, and will
> therefore _not_ cc lkml instead.

That continues to be an invalid argument for two main reasons:

  1) People tend to think local and are not very good at importing 
     context when on unfamiliar terrain.

  2) The 'problem' you outline can be solved with technology by simply
     adding back the proper lkml entries. The number of eyeballs 
     looking at MAINTAINERS is probably at least two orders of 
     magnitude higher than the number of changes done to that file, so 
     it's worth having a good summary for every entry. Or at least 
     it's worth having it for the subsystems I care about.

The problem _I_ outlined, that people won't Cc: lkml if they don't see 
it in the MAINTAINERS entry could only be solved by changing people's 
behavior, which approach in my experience rarely works.

> So I think the rule should be either every section has
> an lkml entry or no section does.
> 
> Pick one.

No, you continue to misunderstand my argument. I think the rule should 
be for you to honestly read and reply to arguments when they are 
presented to you, especially when done twice in a row. You never even 
_acknowledged_ my main point, let alone countered it successfully. 
Hence you came up with this false 'conclusion' prematurely and 
presented it with baseless, cocky self-confidence.

What an annoyingly unproductive waste of time.

Thanks,

	Ingo
