Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaG2OFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:05:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbaG2OFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:05:38 -0400
Date: Tue, 29 Jul 2014 16:05:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
In-Reply-To: <alpine.LNX.2.00.1407052240020.1655@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1407291604260.16390@pobox.suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz> <53B3F556.7050002@suse.cz> <20140702123002.GA20071@mtj.dyndns.org> <20140702134721.00163886@alan.etchedpixels.co.uk> <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz> <20140702133053.GB20071@mtj.dyndns.org>
 <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz> <20140705203606.GC3069@mtj.dyndns.org> <alpine.LNX.2.00.1407052240020.1655@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2014, Jiri Kosina wrote:

> > > The same holds for the kernel threads -- until all (or most of) the 
> > > kthreads are converted to workqueues, the obivous choice, that should 
> > > cover most of the use-cases, has been made.
> > 
> > But, this is different.  
> 
> Quite frankly, I have to say that I don't personally see *that* big 
> difference. In both cases we are making assumptions about semantics, and 
> are trying to get "as close as possible" to the point in time where the 
> set of assumptions can be made as minimal as possible.
> 
> With userspace thread, this is kernel/userspace boundary. With kthread, 
> this is starting of new iteration of the main loop / try_to_freeze().
> 
> We were not able to come up with anything better. Alan, you were 
> stating "I don't see why it can't use the kernel freeze functionality?". 
> What exactly was your suggestion, if not this, please?

Seems like there was no further activity on this wile I was on vacation, 
so let me resurrect this.

Alan, either we are already doing what you suggested, or I misunderstood 
your proposal above. Could you please elaborate?

Thanks,

-- 
Jiri Kosina
SUSE Labs
