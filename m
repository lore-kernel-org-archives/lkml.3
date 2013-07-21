Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3GUMeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 08:34:31 -0400
Received: from ozlabs.org ([203.10.76.45]:56128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab3GUMea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 08:34:30 -0400
Date: Sun, 21 Jul 2013 20:49:40 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: The future of DT binding maintainership
Message-ID: <20130721104940.GC22475@voom.fritz.box>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com>
 <20130720034647.2B7B43E14BF@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20130720034647.2B7B43E14BF@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 20, 2013 at 04:46:47AM +0100, Grant Likely wrote:
> A number of us had a face-to-face meeting in Dublin last week to talk
> about DT maintainership and the fact that it simply isn't working right
> now. Neither Rob nor I can keep up with the load and there are a lot of
> poorly designed bindings appearing in the tree.
>=20
> Device tree binding maintainership needs to be split off to a separate
> group, and we've started with a few people willing to help, Pawel Moll,
> Mark Rutland, Stephen Warren and Ian Campbell.
>=20
> (BTW, even though I've already sent a patch adding that group
> MAINTAINERS, this is not set in stone. Anyone else wanting to help
> maintain should volunteer)

Sounds good.

> Another thing discussed is that we need to start validating DT schema
> with an extension to dtc. Tomasz Figa has volunteered to do this work
> and has support from his employer to spend time on it. What I'm hoping
> to have is that the DT schema will get checked as part of the dts build
> process so that any DT file that doesn't match the documented schema
> will get flagged, and that the schema files will be human readable and
> will double as documentation.

Tomasz, please keep me in the loop on this.  This sounds like exactly
what the "checks" infrastructure in dtc was designed for, but I never
had time to implement very much there.  I'd definitely like to follow
progress here, though.

> There is not yet any process for binding maintainership. We talked about
> a few ideas, but they really need to be hashed out here on the mailing
> list. A couple of the questions:
>=20
> - How are bindings allowed to be merged? Through subsystem trees, or
>   only through the bindings tree?
>   - Through the bindings tree is more work but it will provide more
>     control.
>   - Through subsystem trees means drivers and bindings get merged
>     together.
>   - If we have a schema tool that reports errors on missing or
>     unapproved schema, then spliting the driver from the binding won't
>     matter that much.
> - Do we need to differentiate between 'staging' and 'stable' bindings?
> - What is the schedule for splitting the bindings and .dts files out of
>   the kernel?
>   - Ian Campbell is maintaining a DT bindings and .dts mirror tree which
>     should eventually become the 'master' for merging DT bindings.

It seems to me that the kernel tree has become the informal repository
for board dts files is in itself a problem.  It encourages people to
think the two are closely linked and that all that matters is that a
specific dts works with its corresponding kernel and vice versa,
rather than fdts being the general description they're supposed to be.

Not that I have much in the way of better ideas.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHrvMQACgkQaILKxv3ab8aEyQCgkNeBr0+qw2lclYuW0/47WTve
njwAn0uW3W5JVTqFeSHLm76TTwWglbGk
=8U6w
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
