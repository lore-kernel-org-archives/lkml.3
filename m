Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaEFNuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:50:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:32829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaEFNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:50:13 -0400
Date: Tue, 6 May 2014 15:50:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jan Kara <jack@suse.cz>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140506135009.GN11096@twins.programming.kicks-ass.net>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
 <20140506131234.GD30234@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ipiAXJWFVZGVDOzf"
Content-Disposition: inline
In-Reply-To: <20140506131234.GD30234@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ipiAXJWFVZGVDOzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 02:12:34PM +0100, Will Deacon wrote:
> That said, printing one message each time seems to go too far in the
> opposite direction for my liking, so the best bet is likely to limit the
> work to some fixed number of messages. Do you have any feeling for such a
> limit?

42!

--ipiAXJWFVZGVDOzf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaOiRAAoJEHZH4aRLwOS6rpwP/iv5edb/HlKoy/F29dpARgc+
CdsKItr3U+Ts8hdmZqPkyAQpkOF1cPf8BJAqj/4mIkYabV8Yoc0+Tm3Hi1D0+cYS
R9MRRsgPpb8kTx7gjsz/7qdRx+N3U1+FxezRaLzvd2RtCL4oXui9eJxxASl59P00
koW5R4hhidJ/iTvlGV/VP4f7SytqGC1K4WKk37br8FHsjLfHkBjTAUJa5/WttoIm
geG3d4xwCx1tZW/VYvwmoFL6kwIokv6y+euVPJPIR2mXLzA/0TEcjW7RoOSy7X9Q
aEYjsc2Kzj9wEeP06CPacEM0h0mugKaClALmxd3UlzoOn+5kTJ7Vns/5ByHXXTq4
DQtZ8RKXxlIh7jSLXzTtw+TR8wE7TPIw0OkJNk6fUgTwqUuufzYO29+UT2UxxOxf
iQ90m+4mD945GWpoF0zioA5Ii+86zz/KE9kWje0PoW4Bn1FY1XPpo9MDwfe7kl1R
l2rRMCDjX+et0PR9NWC4yT4LAttTbHT1Cnyr0WOvlH8y7GidV9xd2jaNDGu0GeLy
F5C87Xa3dzB1sZAxPrXlgHXQcVzOzwsK4zbP85sgEy3S24iRJPBdp04cvCgOA9x4
8rA88EW6P0OHK+3u3l/XiUVG916ykV0k5yFVEompfvn2SVfJdQ5uu29xajVn2eO6
/GW9yVL0yStPz8AFkGAD
=e5mk
-----END PGP SIGNATURE-----

--ipiAXJWFVZGVDOzf--
