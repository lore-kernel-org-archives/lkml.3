Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaHAKY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:24:59 -0400
Received: from stinky.trash.net ([213.144.137.162]:54092 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaHAKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:24:57 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2014 06:24:56 EDT
Date: Fri, 1 Aug 2014 12:26:32 +0200
From: Patrick McHardy <kaber@trash.net>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] lib: Resizable, Scalable, Concurrent Hash
 Table
Message-ID: <20140801102632.GA19476@server.your-server.de>
References: <cover.1406882738.git.tgraf@suug.ch>
 <15a766adefc269dd26001474e9b67dbbd0d5bc82.1406882738.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15a766adefc269dd26001474e9b67dbbd0d5bc82.1406882738.git.tgraf@suug.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:51:58AM +0200, Thomas Graf wrote:
> --- /dev/null
> +++ b/include/linux/rhashtable.h
> @@ -0,0 +1,213 @@
> +/*
> + * Resizable, Scalable, Concurrent Hash Table
> + *
> + * Copyright (c) 2014 Thomas Graf <tgraf@suug.ch>
> + *
> + * Based on the following paper by Josh Triplett, Paul E. McKenney
> + * and Jonathan Walpole:
> + * https://www.usenix.org/legacy/event/atc11/tech/final_files/Triplett.pdf
> + *
> + * Code partially derived from nft_hash:
> + * Copyright (c) 2008-2014 Patrick McHardy <kaber@trash.net>

Minor request: german copyright law as an assumption of authorship for
authors marked in the work. When doing GPL enforcement I would prefer
any discussions about what derived from specifically means in this
case and whether this constitutes a normal statement of authorship,
and since this clearly contains a lot of literal code I have written,
please change this to something like

Copyright ... Thomas Graf
Copyright ... Patrick McHardy

...

Code partially derived from nft_hash.

Thanks!

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
