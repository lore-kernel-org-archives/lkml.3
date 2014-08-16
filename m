Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaHPViD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:38:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38955 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaHPViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:38:00 -0400
Date: Sat, 16 Aug 2014 15:59:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140816145954.GS28623@sirena.org.uk>
References: <1406552704-6736-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H88uUF932U8Oj0a6"
Content-Disposition: inline
In-Reply-To: <1406552704-6736-1-git-send-email-afaerber@suse.de>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H88uUF932U8Oj0a6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 03:05:03PM +0200, Andreas F=E4rber wrote:
> The specification requires compatible =3D "adi,axi-spdif-1.00.a" but
> driver and example and file name indicate "adi,axi-spdif-tx-1.00.a".
> Change the specification to match the implementation.

Applied, let me once again remind you to use commit logs that match the
general style for the subsystem so that it is clear what you are trying
to change and the changelogs look nice.

--H88uUF932U8Oj0a6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT73HmAAoJELSic+t+oim9U2YP/04oBlA2cT0KH+dV9kyf5iuD
K3lvs9wfTDDhNVSKI8qCgyLtwcYjcckVqGNeWua/Zo0lLehauvWchtiwnDhZgQxg
ykg5zs1WF4IVyR2uP4j3qSW6ZGN7mD9elFG5YKuPBLGJZKRbipPugkMMVji9n4cc
RDVG0iymWqUoQ1/GN70m4zZmkP/q3XSx9q5K5QPZv56ub4QK5sPuUtRJWQZiUCj5
ySX2Sp64iOqaKkCgJnZ2QgBax3mM7gel2dXEpZsITMX3enejF3NFuvX085t/dzAn
0foAioWlB38wN8yFEoOumlZsUDSjRfYWU4ko3Cy9N2ZgWg7UPo8mmsMrkRQIuuO1
9J3s+cpiB10ZxAF7u4JUu6LCt2vSAZyEIHanW53NkLQhWx9X/A/myIrTtNHnp28K
dd0ndZjTg5W29TD3WPnJa9bpI8W45lD9AIeaAt77oaCy+LPl2daJNy5nFTbO3L+B
HIe2c2L9kwf5s8B7TjPYTfDSXm9axkiPdLokIGiK2ChdM+BZoWas93p27jXHrmnS
TU2ZCZbW7qPy+A/6Q8LLK7TE9OEHA1DlyYwUH9ZFyz4kjNcChi/rttyqSa7G0Yx5
qME19EOaVQ2xNOk1Pzrb91IPfrIj9n4pVND304zRpRZuLwYffbbt0OXIzuGhnOCk
lIxpAMbmxzfOL3/Ow+KT
=WK7q
-----END PGP SIGNATURE-----

--H88uUF932U8Oj0a6--
