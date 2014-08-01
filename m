Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaHAKdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:33:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:51731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaHAKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:32:58 -0400
Date: Fri, 1 Aug 2014 11:32:55 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Patrick McHardy <kaber@trash.net>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] lib: Resizable, Scalable, Concurrent Hash
 Table
Message-ID: <20140801103255.GA7331@casper.infradead.org>
References: <cover.1406882738.git.tgraf@suug.ch>
 <15a766adefc269dd26001474e9b67dbbd0d5bc82.1406882738.git.tgraf@suug.ch>
 <20140801102632.GA19476@server.your-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801102632.GA19476@server.your-server.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 at 12:26pm, Patrick McHardy wrote:
> On Fri, Aug 01, 2014 at 10:51:58AM +0200, Thomas Graf wrote:
> > --- /dev/null
> > +++ b/include/linux/rhashtable.h
> > @@ -0,0 +1,213 @@
> > +/*
> > + * Resizable, Scalable, Concurrent Hash Table
> > + *
> > + * Copyright (c) 2014 Thomas Graf <tgraf@suug.ch>
> > + *
> > + * Based on the following paper by Josh Triplett, Paul E. McKenney
> > + * and Jonathan Walpole:
> > + * https://www.usenix.org/legacy/event/atc11/tech/final_files/Triplett.pdf
> > + *
> > + * Code partially derived from nft_hash:
> > + * Copyright (c) 2008-2014 Patrick McHardy <kaber@trash.net>
> 
> Minor request: german copyright law as an assumption of authorship for
> authors marked in the work. When doing GPL enforcement I would prefer
> any discussions about what derived from specifically means in this
> case and whether this constitutes a normal statement of authorship,
> and since this clearly contains a lot of literal code I have written,
> please change this to something like
> 
> Copyright ... Thomas Graf
> Copyright ... Patrick McHardy
> 
> ...
> 
> Code partially derived from nft_hash.
> 
> Thanks!

Sure, it was not my intention to hide ownership in any way.
