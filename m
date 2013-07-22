Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3GVAGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:06:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46757 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3GVAGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:06:02 -0400
Date: Mon, 22 Jul 2013 10:05:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (sound-asoc tree related)
Message-Id: <20130722100550.553af77b06c5de6a2471a47b@canb.auug.org.au>
In-Reply-To: <20130719100237.GC9858@sirena.org.uk>
References: <20130719135253.2689f6c0e42838f330b60df9@canb.auug.org.au>
	<20130719100237.GC9858@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Jul_2013_10_05_50_+1000_PqX/FFABN3o.7.Y9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jul_2013_10_05_50_+1000_PqX/FFABN3o.7.Y9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Mark,

On Fri, 19 Jul 2013 11:02:37 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Jul 19, 2013 at 01:52:53PM +1000, Stephen Rothwell wrote:
>=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
>=20
> What goes into the final tree that might cause such breakage that didn't
> appear in the earlier merges or is this additional testing that isn't
> performed on the earlier merges?

=46rom my daily release message:

"You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary."

The powerpc allyesconfig catches quite a few build problems.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__22_Jul_2013_10_05_50_+1000_PqX/FFABN3o.7.Y9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7HdjAAoJEECxmPOUX5FEeTwP/icReOVl6wa2FiKrpn/VbEZK
7Et/W5x/ErnwGNldUCqUIMFEyYoLHO2WgMPdI2yyTyQLBHqI5QeEkJutlDinozed
Y31PjkB6pBrGHjGgOzy4/I0/bcWEsu9zOgVgQ0aCdjw5UnZlH7Gawiv2Z9YH4r6h
yJ0NWekxA5wo5l1fDtnFrXbf3/7JJ1n4zAq5E2+a10+AQpG5lZcSNB6oeRObRdd0
xx2g2Zu+oi+emXu/Ev7DuP3bvt5NNhikykWX68O5HohxOcZEULElrK82nDJ1yvW0
Mi4OgJ3BrDuOeHN4QNsFJxhuyd85EryJPCrMEHVCQHhe5G25+JiLS+yTYPpObnX0
4YwRB4bmNDWydhKnnubHEJ2igSADuZiR+UxlF6JE7Biw2Ki7evux5jZAO1xtTh+E
hJiereNa9+6ojhIKbMw74oojjcc/FV1EezadqsIBDUprp8cdZe1EUSbnkEB0wit2
s/XvQdfEqHxWiaLTwDdsSwiv2RkNVahpS3aIB/XHYzh6mMXbk+8+SXZQbdMmnM92
3Y20mb0D+P/7fAxpfVlQfY7ghHPl6X05WXj4geH2XRizI8Pb6n96smhY6LBwsEVO
25ma73bVzwCBbEFcZJCNmsRp3ynLj9qeMg1G2IhrtqowuWwBEKkCjHyI5LP/g4hK
xUpJX9K9+fm/nQHx6CnC
=5ICy
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jul_2013_10_05_50_+1000_PqX/FFABN3o.7.Y9--
