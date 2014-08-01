Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaHARsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:48:35 -0400
Received: from sauhun.de ([89.238.76.85]:38356 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaHARsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:48:33 -0400
Date: Fri, 1 Aug 2014 19:48:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, kernel@stlinux.com
Subject: Re: [PATCH v2] drivers: i2c: i2c-st: Update i2c timings
Message-ID: <20140801174830.GC3277@katana>
References: <1406130247-19197-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <1406130247-19197-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 05:44:07PM +0200, Maxime COQUELIN wrote:
> The i2c timing values specified in the driver are the minimun values defi=
ned
> in the I2C specifications.
> The I2C specification does not specify any default or maximum values.
>=20
> Some I2C devices are out of spec, such as the HDMI link of the Toshiba 19=
AV600
> TV, and might not work properly with minimum values.
>=20
> This patch adds a 10% margin on all the timings in both Normal and Fast m=
odes.
>=20
> Trial and error method have been used to find the minimum margin necessar=
y to
> have the out-of-spec device working, and a security margin has been added.
>=20
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Applied to for-next, thanks!


--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT29LuAAoJEBQN5MwUoCm2yBIQALXNAFBm8alftzfUqqSoXQnu
SQtn2gQejdYZs+xxr59jSDP75cmXWEV8iPYBMZxToT5oGq/7Bsy6IzDTu7Js+hQ/
o9lhSwvC9PS0i9CyFDD54ZTAjGAl2E9nWKXppOnIzj47b/6S2PgG8LqP833SZa1p
CFVBABLqtJiF7ejoQbM85bCorlRQYu1PVYsgpPcb+TJVtOO2Vet+CsFq8amzHH6Y
3NxMtyiWQ1rweBG6LNmxMMIPvbcfvJuBHTEYUIrUJEo6uwZS4RXUAifqWv3xtNR9
UbEiRL7Cn3SEP5UxkJhnR8lZ2iwlv6eLrL0Q4Bv4oL5PoZbuguCcbkTnww791r7/
B5oCFN11Nj/87pPSkCZ9nuRwbZ9GHtBWMihaEIaCf12zXGwKiGJQ0EBslvfr7r8X
Fwvm4iczq8xfTzhL2dGV0m7dA9sHGihYfAZC9e5vFJlysE5ZvGC5vUG2E9uzv3JD
yGCRTjBGT+Tw4UFaNqXIIOnyouGlMt278XsOypOyGjJA7VrGmfFjtTOphAcJm14e
mvmt3czVdlVnOK5Q28Cn+Rd1BU3bdmou7xLhYd+aFLSHmO8wJnQlXxhSEXt+g3n/
qLrr5hfma+tbjHCx46z8MUd73VGMf3nR4m7BugwEXQj4v/8N7Koh69gzCJjyu3QQ
CqoPI+hCIbpVBAsXxxcy
=jQjo
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
