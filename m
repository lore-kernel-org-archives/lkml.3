Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaAJMIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:08:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaAJMIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:08:40 -0500
Message-ID: <52CFE2BB.8090004@ti.com>
Date: Fri, 10 Jan 2014 14:08:27 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
CC: <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v4] video: add OpenCores VGA/LCD framebuffer driver
References: <1385739911-6541-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1385739911-6541-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lnC0LCFNacpbQCeEtLxq3qLhp33CjaLtq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lnC0LCFNacpbQCeEtLxq3qLhp33CjaLtq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-11-29 17:45, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
>=20
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
>=20
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

If I'm not mistaken, this driver has been designed so that there can
only be one VGA/LCD core device on the system.

It would be better to get rid of those static structs, and have the
driver data per device as it should. That way the driver works even with
multiple VGA/LCD cores (although the video mode module option is a bit
odd in that case).

 Tomi



--lnC0LCFNacpbQCeEtLxq3qLhp33CjaLtq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSz+K7AAoJEPo9qoy8lh71S2gP/0Y3dGoTCXCdl9qd2Q2TWHZg
qC6hEXHdoEtPKQ3/CbKLl81S17AScG0Vra+Z/eTFaC/Bn2iSTrn4WY6yScZkdikY
qDHIGqhvmtbK8Pftc7xuGpGOAvvSF9ejKkF+I/ee5gXDLqlQzFgAWhi+Z68TA50t
6AoCrWES+HoRruAbG4rBsryuz7vfaTSXOFpojEITSZUCeVxkGuM5q+F9iHJUQZiy
efjWGDqbgBQ5yL79FcFhsSaF8CU48GPFQGSn3BYFNKTpv1dHSpFTGHq5sXrAk0eX
I06YR7RLLrXvlMkaTcQtTySp0TwlNZ+D5IoI3RA3kMzgSP+v62OSo05Riz83M2v0
frtqEo2fZ/mU8vrfxdTGBY1DLUQJ3++m2fI9gk8y2MYm6uXA8j6mAzdXny7nfhhu
RPFbffyeBdnzR45UTOFeE9uIwgg/9MsmIKXpK0iHr9euArmoreoRVwlNOXmJGhfS
odb64r17F/oMrmfy5Nv5BClX8tKmaPjTpuWfFvROUpDANAvw0U7N747RZNa4R1GR
7C/UFI8kD+KhFVlV1pQ5kEsBp88xWYLHQwpgK0CKC8/LzHbvtg028jpf4Sixh+Hp
DJ5pLIPjQmeOyJ0DLLWf3yesWnoj/mp3asfAXHgqIjWccAEBTGtetN9CyCJfKm9N
CmNyK2iasCSpQlZjQ+ad
=v/JJ
-----END PGP SIGNATURE-----

--lnC0LCFNacpbQCeEtLxq3qLhp33CjaLtq--
