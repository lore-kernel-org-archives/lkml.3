Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3GVCax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 22:30:53 -0400
Received: from ozlabs.org ([203.10.76.45]:38976 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3GVCaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 22:30:52 -0400
Date: Mon, 22 Jul 2013 11:27:27 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Jon Loeliger <jdl@jdl.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
Message-ID: <20130722012727.GA6806@voom.fritz.box>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
 <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
 <CACRpkdb2bPQOD2CBzbF0K33mZZwKwGSCO6B4djesVd5DR-Z1tA@mail.gmail.com>
 <E1V0txk-0007v7-0J@jdl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <E1V0txk-0007v7-0J@jdl.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 21, 2013 at 08:46:11AM -0500, Jon Loeliger wrote:
> > On Sat, Jul 20, 2013 at 5:19 AM, Grant Likely <grant.likely@linaro.org>=
 wrote
> > :
> >=20
> > > Device tree bindings require a lot more attention than they used to.
> > > We've got a group of volunteers willing to take over maintaining
> > > bindings. This patch adds them to the MAINTAINERS file.
> > >
> > > This group still needs to work out a process for maintainership and h=
ow
> > > they are going to work together. I recommend that they set up a shared
> > > tree on git.kernel.org that they each have commit access to similar to
> > > the tip tree or the arm-soc tree, but it is up to them.
> > >
> > > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > > Cc: Pawel Moll <pawel.moll@arm.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > > Cc: Ian Campbell <ian.campbell@citrix.com>
> > > Cc: Rob Herring <rob.herring@calxeda.com>
> > > Cc: Olof Johansson <olof@lixom.net>
> > > Cc: devicetree-discuss@lists.ozlabs.org
> > > Cc: devicetree@vger.kernel.org
> >=20
> > Excellent move.
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
>=20
> Perhaps it is time to also place the official repo
> of the Device Tree Compiler on git,kernel.org as well?

Sounds good to me.

Now that I'm no longer at IBM, and don't have the associated
complications with their Legal department, I'd rather like to resume
having direct commit access to the master dtc tree.  So if we could
get Jon and myself, at least, push access to a tree on git.kernel.org,
that would be nice.

(Fwiw, I do have a personal dtc branch tree on github at
https://github.com/dgibson/dtc).

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHsin8ACgkQaILKxv3ab8bMgwCgi79Rh0F6GxowYhF2laS3UPKS
4xAAnjmguvbg+UvmeRneTvoKnoMe549T
=AYzK
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
