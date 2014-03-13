Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaCMJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:16:27 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaCMJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:16:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg KH <greg@kroah.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Date: Thu, 13 Mar 2014 10:17:56 +0100
Message-ID: <3306881.foYD0IDJn0@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140313005026.95bb2222270ded24b0a5deff@kernel.org>
References: <20140313005026.95bb2222270ded24b0a5deff@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2435935.JEFXHChFDC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2435935.JEFXHChFDC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Mark,

On Thursday 13 March 2014 00:50:26 Mark Brown wrote:
> Hi Greg,
>=20
> Today's linux-next merge of the staging tree got a conflict in
> drivers/media/v4l2-core/v4l2-of.c between commit b9db140c1e4644d
> ("[media] v4l: of: Support empty port nodes") from the v4l tree and
> commit fd9fdb78a9bf ("[media] of: move graph helpers from
> drivers/media/v4l2-core to drivers/of") from the staging tree.
>=20
> I fixed it up by essentially dropping the support for empty port node=
s
> since there were more context differences than I was comfortable with=

> in the changes in the new code.

If I'm not mistaken the move of drivers/media/v4l2-core/v4l2-of.c to=20=

drivers/of/of-graph.c has been canceled for v3.15 and related patches s=
hould=20
be dropped from the for-next branches in the very near future (the v4l =
tree=20
has already been rebased).

=2D-=20
Regards,

Laurent Pinchart

--nextPart2435935.JEFXHChFDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTIXfLAAoJEIkPb2GL7hl1NOUH/2I3BQsUpF6ekd4pBgDD9No2
CdruRTemTqGynwtjZSzh/8eZVg9GfovvmQ+JII5keBF8HcjgBjZed3ClctkrnILo
Y0CTfkiXzxov87LFEO27BWCuph0e3sL959xLd+IO4vm8MRClRmaycG4oEZiDeiLE
7rBAQuZj9ZFNeKzcXtA9NJjM2WyRxK5Y3RNJwjuAcDJxJNGHtaksPHqQcYXVZGzd
r9zAh7ODeSOH3FKh+g2mEF47RlvWWHptgiVHVp1r3BmbThQya5ETMcpifFuWLmr1
jbK/8R+cRhZd0tGFgVO7cpzu90QCaV/ZgzI+4NZb/b00HKq104VgNP/8AI7NvQM=
=g2t0
-----END PGP SIGNATURE-----

--nextPart2435935.JEFXHChFDC--

