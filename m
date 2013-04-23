Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3DWNtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:49:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45355 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab3DWNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:49:22 -0400
Date: Tue, 23 Apr 2013 14:49:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: perex@perex.cz, tiwai@suse.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        lgirdwood@gmail.com, marek.belisko@streamunlimited.com
Subject: Re: [PATCH 1/2] ALSA: ASoc: spdif_transciever: Add DT support
Message-ID: <20130423134920.GM5019@opensource.wolfsonmicro.com>
References: <1366378725-14471-1-git-send-email-michal.bachraty@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q8dntDJTu318bll0"
Content-Disposition: inline
In-Reply-To: <1366378725-14471-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q8dntDJTu318bll0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2013 at 03:38:45PM +0200, Michal Bachraty wrote:
> Add devicetree support for this dummy audio soc driver.
>=20
> Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
> ---
>  sound/soc/codecs/spdif_transciever.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)

New device tree bindings need a binding document.

--q8dntDJTu318bll0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdpE6AAoJELSic+t+oim9S3gQAJpNt8cnRynw40RCNtws+FHe
1XFKTNJJKyd4sQ4s3vYvCTdw1da/aO1FfjA/uxcOUB0T4h8MtT6kVG7SJJhDfOWx
KgtcL46IKeilk3wXoFuMlh7zQhXtsYsY2ELZujaxId1U4qfGnx0YmE30O77nevO0
qNL/oZhBlQUo10zGVhVYrvN2a1vENQsroEXHw9cICTlKSGSLM7QgvnvjlZbXoYMm
kYtYXsgYSCV4QDtbCIWkeBf9a+MUoETSxC87KitMP6yEH/jlvuZuq0ArnNlzyIY8
tE/WQR0ULto2FFDauJi0DZGJyEHseIaHIfbeTglMD5Z2bN68iaH9GTEhkd87C0b2
uGDxx7hkCeg2t63lV9im1uZ8tccyJtbcY6tzQq3I5/5eG1hVHPyu4TIjvCCs40tz
bUOxrRIysLQi0n1+QYdpXCLQW0dDNoq5ztslI9w6klQmHrowJq+hIydxX+PqdNTu
8miSV2KyttluE5JQnuWJhPSAqpQUFoNUnssv1ETr3EltTwKJdt6eGXxorl7CDdWa
IPWrao/VwqDad6JNgUQbDHanv8dPYh8rewihshKKks2SVeff9OR2LVWASHnwY/TQ
WhDfPlFRoqAyddq2itS4iri/i43TjmAFJJaAK0pQeMFZrGyLOp4CbhSwdaPuw1hu
qZBQ0wlXP2EnTNv+jJ4k
=14D6
-----END PGP SIGNATURE-----

--q8dntDJTu318bll0--
