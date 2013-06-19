Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab3FSQmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:42:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56656 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3FSQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:42:52 -0400
Date: Wed, 19 Jun 2013 17:42:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, ldewangan@nvidia.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Message-ID: <20130619164224.GZ1403@sirena.org.uk>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-5-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="puacTriGDskFP02p"
Content-Disposition: inline
In-Reply-To: <1371621470-22279-5-git-send-email-j-keerthy@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/4] regulator: Palmas: Add TPS659038 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--puacTriGDskFP02p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 11:27:50AM +0530, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
>=20
> Add TPS659038 support.
>=20
> Signed-off-by: J Keerthy <j-keerthy@ti.com>

This doesn't apply against my current tree as the PMIC bindings document
isn't in mainline yet.

Acked-by: Mark Brown <broonie@linaro.org>

assuming there's a tree where that does exist.

--puacTriGDskFP02p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwd9tAAoJELSic+t+oim97boP/13KOIGcQ/KOAq97/yNqWjNg
Qyed+YxGGzlTRS8zenpmrsrBhOh3bSWFIJ14bjqN0NzgdcwZJMqiBM1mXB90Rpcd
otJHjq9hJB8KBM5/40e65iRzdnmZQjs6DJM4vkwRCIMBhYNAYZyUMYZpApusGb0f
HDc7q7SeTHZaeUJ1bCXG8JfizUmY/CWUxHa3q3O6nlhV0WjYKRIXJy4QnEc9umgB
BDbi/z02U6FMMQ6SU7ZnqWQMyIOHy8Aq9MFKbho9q9EfDs7cNmbO4NcbNZtvDDUA
ZIyt9p/9l+FRAZK5DQ6+Zk38EhBybrDnRrhNXC9gwOg9qMLSAM/ke0wZ7YR5UZxU
02l9SKAqETHKYOHmSUcDHKBAadG6hl9NXdQzjkl8S9fEdx0XAhwAP+Q8wRpbRZHr
gG1czpVeqBDzXkzfKZvlFjSSkABjjrJFptUZchLNIcNV27sVtlny+ArusA08CB3T
9I8BZGkI1OYSu7mHaraGY27PfK1HWZ+4dKQb1L4zA/clH1sb8JMxFOzvScKsB/Ki
QJtOCkCaapWaHeJdeZpJdU670wIVknJUgq7y8YlVqJVjBG7S0a8d4363j8uHF4vq
q3aS+EBLnXMGmHcaGCICcfFGCb+eS+2wJa+K/AE6w4SuapADhcdwVl3oERrFpjU2
uNexqo/6tEraYCq3mfIN
=kjBq
-----END PGP SIGNATURE-----

--puacTriGDskFP02p--
