Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJIUrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:47:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59999 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaJIUrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:47:16 -0400
Date: Thu, 9 Oct 2014 15:46:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rabin Vincent <rabin@rab.in>
CC: Felipe Balbi <balbi@ti.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141009204637.GE25729@saruman>
Reply-To: <balbi@ti.com>
References: <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
 <20141009204101.GA25955@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Content-Disposition: inline
In-Reply-To: <20141009204101.GA25955@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 10:41:01PM +0200, Rabin Vincent wrote:
> On Thu, Oct 09, 2014 at 11:26:56AM -0500, Felipe Balbi wrote:
> > alright, it's pretty deterministic however. Always on the same test, no
> > matter which USB controller, no matter if backing store is RAM or MMC.
> >=20
> > Those two undefined instructions on the disassembly caught my attention,
> > perhaps I'm facing a GCC bug ?
>=20
> The undefined instructions are just ARM's BUG() implementation.
>=20
> But did you see the question I asked you yesterday in your other thread?
> http://www.spinics.net/lists/arm-kernel/msg368634.html

hmm, completely missed that, sorry. I'm using 4.8.2, will try something
else.

--=20
balbi

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNvQtAAoJEIaOsuA1yqREylQP/0Xz2mxKi04305vCKFevaefK
PLGF+pyX3OsF+LaoFU0GrL7Itdx4JD+2ZNFYoBGmSsWLRj1PRosSJWDY7TH3ojtn
wsRSP/CVRsXLOWsdBIkcq2/9cqfST4KJwmORgA3lTwx627vyvrb0ASfOby3n1gm4
HQMrQwiF7I+3N+HaD9e/bn8eeTJ1evVNvDHbJFyc0FkJU6Sj2Lu/K8DyuOId6gmA
bZhJHV3Z1P6RViCkEfxBFdogWT0xTS9kma++9nF/0L6peL+65MF+/hu+m25jpvR+
heNU5j1BjYFvP1Welxv7z87PETZ7r2CcJJEaXPpwJaFBc2YJHXkkKg8ohSt6oUyE
1PS8mbzDpYMfUn+TIv+mKeAm6LRiXg6e1rSCIK2xXv1Ti8tq1qzBEBqApKCDU8mE
lCA931lLkrWlMnFItiDjdXmaNMLy3OP3VTn08Oqk9iduCc17PvURyVEoFElesJ8k
6lddvGGW2QkKb6rx7IGmD9n27ZzaynYif4Kc3H2Tq0jS6FrOBG1kwAe0qiET2l1m
UhOlYZuXWxuhmHTpTTbGbJLQxBGj38p23ep7/n5wB6SgsVqL55VSJaU/DWH59d46
XcwYn/uPe9uabgTASrXUrKYY1lpLMmcBIPQPy6S1FfpS+1I1rx0u3hkuOkpoEROq
AQLpNLW4YEEbUAnvkdX2
=CTwi
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
