Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab3EGAU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:20:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55414 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3EGAU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:20:56 -0400
Message-ID: <518848C0.2020808@ti.com>
Date: Mon, 6 May 2013 20:20:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com> <5188212D.3030904@wwwdotorg.org>
In-Reply-To: <5188212D.3030904@wwwdotorg.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NXHNXUMXQXHPKVCUCSQC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NXHNXUMXQXHPKVCUCSQC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06-05-2013 17:31, Stephen Warren wrote:
> On 05/06/2013 03:00 PM, Eduardo Valentin wrote:
>> Introduce HAS_BANDGAP config entry. This config is a
>> boolean value so that arch code can flag is they
>> feature a bandgap device.
>=20
> What does this patch have to do with device tree (there's "dts" in the
> subject)? What's a BANDGAP device?
>=20
>=20
In fact, this one has nothing to do with DT. dts in the title is a typo..=





------enig2NXHNXUMXQXHPKVCUCSQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGISMAACgkQCXcVR3XQvP3S1QD/WHvBdG04DHsv66nQnrJ2Sdum
ABTkgeWhZfFVeUzJMv0A/i+m4TpvsVlpK2NdUuDO3IkxF0DGKxbsCaH4IaejVXtf
=b43u
-----END PGP SIGNATURE-----

------enig2NXHNXUMXQXHPKVCUCSQC--
