Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaCDIYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:24:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55264 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbaCDIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:24:22 -0500
Date: Tue, 4 Mar 2014 15:46:47 +0800
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20140304074647.GE13126@sirena.org.uk>
References: <1393911933-25149-1-git-send-email-b38343@freescale.com>
 <20140304064642.GA13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Content-Disposition: inline
In-Reply-To: <20140304064642.GA13126@sirena.org.uk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze200 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 02:46:42PM +0800, Mark Brown wrote:
> On Tue, Mar 04, 2014 at 01:45:33PM +0800, Robin Gong wrote:
> > support pfuze200 chip which remove SW1C and SW4 based on pfuze100.
>=20
> Applied, thanks - however I just noticed that you forgot to add the
> compatible string for the new part to the DT binding, please send a
> followup doing that.

I've dropped this patch since it fails to build.  Please fix and resend
(along with adding the compatible string to the DT binding).

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFYTkAAoJELSic+t+oim9seQP/1lWitac+ezfvv4rbN41yjA0
pUwQS3LBxumfXMqmRVPAcH1nel4JISw3sS3dKZP53QM8Ni3+HEGZoFsNOdnfh4ie
I0hgDPLMwrf01urK6hz/QzNcAg55ro5/oar06Xz9cQMiKykN1YQret0/L5eerOeh
TX9qjLuBHSZ/RqYpVnQSAgX3T0GsV2xgon+kHAVIgho0fts9Uxq9N3oHNRoMPOSp
a0LNerwMuy3AfXloZwfs1EJ6jX2Y73o/nXy1dm1lvo0rZ0VsIbc8fmWfku4o4aZe
nUiLA57h8mgauGsgoKF6SpWMJcNno9KpT4vlZ+zkLMJgYCg+zcijG2n81+shtPzl
mJvJYfSCswG2/uUucqgqs7Jc6uUW6N6lgycPIIj9bHTO/DXWu5vgoWD96v7ZufdU
Gd6WY/L5c8hgZpA2hqne79I4J6vNFD4Yucw7AmJ9plz2vpNm8cDTaR5kXbsqNHEf
9Snj1X/xmJornW6Q6ybwLnOAel4Eip4bOZamtDXRwss9ajcR02MDuePhVyB7iYGA
WNlrCsZ21MFnqvycZQHXhaPpQULTz0zqwIi2MPU/qOcVXV1FvXttfW/SG201sA/2
GmbVxqLnLkvLOv+LNkIAmjUbMfGt1IjCHvi+pjjhmXKUP4jBID6CVlrSLND23jTI
ZeVetA+f6n8b+IQTIGQ3
=8Ktl
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--
