Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaKLUfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:35:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33976 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753190AbaKLUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:35:04 -0500
Date: Wed, 12 Nov 2014 21:32:00 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Roman Byshko <rbyshko@gmail.com>
Cc: linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 0/5] ARM: sunxi: Add support for USB OTG PHY
Message-ID: <20141112203200.GC20972@lukather>
References: <cover.1415645258.git.rbyshko@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 07:55:05PM +0100, Roman Byshko wrote:
> Hi,
>=20
> There is already support for two USB phys, which are used for
> USB host controllers on Allwinner SoC aka sunxi.
>=20
> This patch series add support for the USB OTG phy (aka phy0).
>=20
> The code has been tested on Allwinner A20 aka sun7i (Cubietruck).
>=20
> Best regards,
> Roman Byshko

Merged patches 2-5. Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY8PAAAoJEBx+YmzsjxAgmhsQAJzsvZTFj73kt/ritg2steOS
txPTl0qikhSJ0r/h+PcqKt8ZxXRtTCvHYKJukwbHC6udZTXOYYAMk7GBw/LDOh+8
D80qWXgWTLaRpU3eLYoxVlYUgklGmPab4U2nE/VY/lzHM8T7PUD7/SlgOB/DerdL
3K/QiCVhKkYKoZi+UQ9WaewtYY9JdQJww+sTwze/kQzCv3OK6GYi/LMbKnfZknJk
ZpAItZ6KWv2nM+AsNvkB1bfM8o7Ci0OHEp3/xt9gldTMmPJDuGhjCJXGwUnrZKuE
bO15fvzKuLcHMvVsTQxkRVWOe1eykecQsWrId7kS+uD1+YYqf8LjMymz4w9PnZgR
BMbPZ1fL+5hLV0XPBok2WEG/oZ0791AQFVY9NqEYTHDLa0xrk8/xq7Sy39GtEqNL
8eOETdiq7iquz8LLhOunC8lgZLGaiXUV9eReDFoVzAwFtT/ddo+BAXG+vkZLewRY
3127bbZf4/SD87yzvsnqFUOvv/x5NNiw6hLDMocWfHA8HLRQLL8TYtnm47g4E83M
Fr6hojHcSpUKZ3FGH7syBJjO0+mlPVkz4mrUHYqBpjVUS70oQysBwDT2OzkAs8Di
QuWn7HQgduorYf3nRUHBkhvFOD2m3BcAZ+Jie47AT1Zl97HnI16+lN84yvhHXrXU
NJAKKmVTim5mVRjUVaqh
=4nBX
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
