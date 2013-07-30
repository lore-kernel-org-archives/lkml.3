Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3G3B51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:57:27 -0400
Received: from ozlabs.org ([203.10.76.45]:35231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3G3B50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:57:26 -0400
Date: Tue, 30 Jul 2013 11:50:31 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Dave Martin <Dave.Martin@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
Message-ID: <20130730015031.GK29970@voom.fritz.box>
References: <2469263.vMN09Q7Tzi@flatron>
 <20130729150124.GS29916@titan.lakedaemon.net>
 <20130729164905.GB2280@localhost.localdomain>
 <20130729172339.GT29916@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q6mBvMCt6oafMx9a"
Content-Disposition: inline
In-Reply-To: <20130729172339.GT29916@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q6mBvMCt6oafMx9a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 01:23:39PM -0400, Jason Cooper wrote:
> On Mon, Jul 29, 2013 at 05:49:05PM +0100, Dave Martin wrote:
> > On Mon, Jul 29, 2013 at 11:01:24AM -0400, Jason Cooper wrote:
> > > On Mon, Jul 29, 2013 at 02:21:52AM +0200, Tomasz Figa wrote:
>=20
> > > > b) What information should be specified in schemas? What level of=
=20
> > > >    granularity is required?
> > >=20
> > > One item I don't see in this list is node ordering.  There's been some
> > > discussion lately on deferred probing (re boot times).  If we were to
> > > intentionally declare that DT are parsed in the order written, then a
> > > lot of deferred probes could be avoided by moving eg the pinctrl node=
 to
> > > near the top of the tree.
> > >=20
> > > This doesn't impact buses as much, since the nodes needing the bus are
> > > already children.  However, anything accessed via phandles: pins,
> > > clocks, regulators, etc could benefit from declaring and enforcing th=
is.
> > > Eg having the dtc warn when a phandle is used before it's correspondi=
ng
> > > node is declared.
> > >=20
> > > Not critical though, just a thought.
> >=20
> > I don't think that siblings have any defined order in DT.  If reading a
> > device tree, there's no guarantee you get nodes or properties out in the
> > same order as the original .dts file.
>=20
> That's why I raised the point.  If people think encoding initialization
> order in the DT is a good idea, then we should change the dtc so it
> compiles/decompiles in the same order.

I'm not actually sure what you mean by this.  dtc already preserves
order between input and output.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--q6mBvMCt6oafMx9a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH3G+cACgkQaILKxv3ab8YmcgCdEzwCl0StxQVzfzE3aDk/O3VC
4ecAniijNIkuDXdYsEFyuKWIot7e43hX
=4bCl
-----END PGP SIGNATURE-----

--q6mBvMCt6oafMx9a--
