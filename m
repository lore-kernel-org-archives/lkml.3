Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3ISNX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:23:56 -0400
Received: from ozlabs.org ([203.10.76.45]:43733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3ISNWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:50 -0400
Date: Thu, 19 Sep 2013 22:18:18 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jon Loeliger <jdl@jdl.com>, Olof Johansson <olof@lixom.net>,
        frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc PATCH] Ensure all tests have matching reg and unit address
Message-ID: <20130919121818.GB3551@voom.redhat.com>
References: <1379535782-12667-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <1379535782-12667-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 02:23:02PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> node that has a reg property must include a unit address in its name
> with value matching the first entry in its reg property. Conversely, if
> a node does not have a reg property, the node name must not include a
> unit address.
>=20
> Adjust all the dtc test-cases to conform to this rule.
>=20
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Yeah, the testcase examples were built as purely syntactic exercises
without really considering dt content conventions.  Fixing them up is
arguably unnnecessary, but certainly doesn't hurt and makes them
better as examples.

Applied and pushed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSOuuKAAoJEGw4ysog2bOSnwsP/ibs8gr+BGLfowEehe1G21CO
xzjngFEvyRvM8jcJ7xsV8XfLwd0nbxq3LiTSzvUIDibguKNiSXk+gjaCDhS0mw2D
MnjUauayB+nwXLBrAwU6Yb+oHSJ4qJd3h+lrJv8Kn62Kv2XbtRitay11+fWDegaD
LliEL0ZbiIEKryibVvwpbST+4f6tXrLcDevhu0UnvVmqrv2OcgyBmYAUpxsYsIOA
6/8GRJFxSFQRvSxJjUao9RBZ8UOKvrLQ2yY+9lL78b3HvPbVr0N3/2NNRCa4NJ3o
VFmbCcjI3Cf2Oq+wTN7JLahHeppJkbB1PTmBLlNcBavuCfXRUFZfPZOHdy7Ilv8w
PkkIM1hwfNcp8fznJakvzIzTmJSKupFkA2diuxD6JjOV67lPAr9EAk2Z6sKzZv/X
u6sdN5yOHig6E3apt5M+DWGyqc5isReXDGhSHfD23zemnyjY09MczeE6sjX+5NJH
fxlDbx3KLwLghe7LpH08CuxoytwXauPERP/KOZUHlq9xU+RYWvb/eG8Cbw8qEKV9
lXZWKhvbleQt51aV4U3f4RHHJ+mTvv7DWZAoHWM0+4Ff6UxswqSZ2wov1/+n0f9s
mSuYngYKQKNQ2DObwQCaQ2Gd4uk6C+FeMynG3cq0FI74vEtSKImqfuIL2eZUUxD6
onYajGOG204HPmy2tg8H
=0jP5
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
