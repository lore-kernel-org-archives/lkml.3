Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbaDTDZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:25:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33093 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbaDTDZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:25:44 -0400
Date: Sat, 19 Apr 2014 22:22:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/8] ARM: mvebu: Add USB3 UTMI support
Message-ID: <20140420032255.GD26893@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
 <1397816563-9000-5-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <1397816563-9000-5-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 18, 2014 at 12:22:39PM +0200, Gregory CLEMENT wrote:
> The usb3-utmi registers allow to configure the internal USB PHY of the
> Armada 380/385 SoCs. A small initialization is needed to be able to use
> the USB3 ports.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

looks like this should be a generic drivers/phy/phy-utmi.c driver

--=20
balbi

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUz2PAAoJEIaOsuA1yqREO4EP/jNZO1AxWmt82Jibv1FYvn1B
zZNy8kl8oldc+CARHLI50TdUuN6BEFNQFeusOAVhSkPvkVjRu3/eDAukuZlJTLEN
hdfR3YUC+30ZpDPPYIqFyPKkEayzh/c5HnMWnRURxnraoi1CYKvHFQu/TDV/zAS+
QO8AN73mXwtlG7Z9N2f+V+56ocet9PYXAkv+VgOD3DyTuDdbmY7tqxnmwFrm5jpH
SE1vqic3JKYZlV1Ujali6KEjX79cp2aSh1fmAZqeRfoefkZ2pOGrltvi2mHk6bwZ
Ky2phO58Wel6tCRk1liPAbGCAF/Wc+5k5Ws5VOT8gvtjYQbTGV1OJvyBLHhC+bpy
2y8DwcPCB1jP6mr9p1IDTCwP6dS68svewYEtOrO1heW0dDonIfmzoTnVzr/+wHNI
vqZNw4NW1XR1EYXmOUxdkPBC+jCf1kiqM0zoQ4BxfldVuoylHtLaxpOBDsQmJyqG
HLyuIgOo7y3utTM7EJhRE6TSR+lk1d/1KbpHkmSxhECxc3vkuL5CjhCL3YZ31HGX
FEhN2pmtwsRrl2HxM8lzE21QmdWjlPwYkrMbcIBWvldQ8KodETFruavnsZFFJYnj
64ivZ7YqYey7MiQG0GEeiLD8nzJDL3tBDopWgYPcujgoO8qsEM7pyfTKgdcpBSM/
YEaNzxfP5wd37SEKdTBK
=8OR0
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
