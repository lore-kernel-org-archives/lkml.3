Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3ITNIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3ITNIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:08:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379677551.2021.25.camel@joe-AO722>
References: <1379677551.2021.25.camel@joe-AO722> <1379482610.1787.7.camel@joe-AO722> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <1379459317-13046-6-git-send-email-daniel.santos@pobox.com> <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net> <1379639226.5862.9.camel@joe-AO722> <523BDB55.2000008@att.net>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
Date: Fri, 20 Sep 2013 14:07:38 +0100
Message-ID: <23301.1379682458@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> > Yeah, I do agree, I just don't see how to do it without introducing 
> > unnecessary bloat.
> 
> I think the code size cost of %pE is pretty trivial
> compared to the log size/runtime cost.
> 
> I would not want to see it used generically.

I suspect he doesn't really need to implement a "strerror()" function but
should rather build it straight into printk()/vsprintf().

David
