Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaKDOot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:44:49 -0500
Received: from mail.us.es ([193.147.175.20]:43549 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbaKDOor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:44:47 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19583. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.203267 secs); 04 Nov 2014 14:44:46 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 4 Nov 2014 15:46:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141104144632.GA11096@salvia>
References: <20141029215602.535533597@goodmis.org>
 <20141029220107.465008329@goodmis.org>
 <20141104080535.5f651713@gandalf.local.home>
 <20141104142236.GA10239@salvia>
 <20141104093150.7410f6d0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104093150.7410f6d0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:31:50AM -0500, Steven Rostedt wrote:
> On Tue, 4 Nov 2014 15:22:36 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Tue, Nov 04, 2014 at 08:05:35AM -0500, Steven Rostedt wrote:
> > > On Wed, 29 Oct 2014 17:56:04 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > 
> > > > [ REQUEST FOR ACKS ]
> > > 
> > > Can any of the netfilter folks give me an Acked-by for this?
> > 
> > If Florian's concern were addressed, then:
> 
> Yeah, the change he mentioned was done is 3/8. As that was written by
> Joe Perches, I did some work that he missed and put it before his
> patch, which showed a discrepancy between the two functions. After all
> patches are applied, it should be consistent to his liking.
> 
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > to this patch and 4/8.
> 
> Thanks for this!
> 
> Can I get someone to ack 3/8?

I don't see any 3/8 in my inbox, only 2/8 and 4/8.

Let me know, thanks.
