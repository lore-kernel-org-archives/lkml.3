Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaEJMud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:50:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50753 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753141AbaEJMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:50:31 -0400
Date: Sat, 10 May 2014 07:40:37 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] i2c: sunxi: add P2WI controller support
Message-ID: <20140510124037.GK7047@lukather>
References: <1399715163-11291-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fyA1p1RlO9nWxe3v"
Content-Disposition: inline
In-Reply-To: <1399715163-11291-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fyA1p1RlO9nWxe3v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2014 at 11:46:01AM +0200, Boris BREZILLON wrote:
> Hello,
>=20
> This series adds support for the P2WI block used by some Allwinner
> boards to interface with the AXP221 PMIC.
>=20
> Best Regards,

It looks fine now. Thanks for your work.

You have, for the two patches, my
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fyA1p1RlO9nWxe3v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbh5FAAoJEBx+YmzsjxAgtTcQAL8uDzQeZxY93OM+fX9sdUcg
AY1i2sSfY4mJo8Vgj7VrJUnmvCB21xiNNRVMBUgm3jCu4eU0ooqKu4nbxAw5MZND
v7o9FvEV0+STHbZjTihd/NTGBu3ofSENf1OPjdrreCG1/mlAfYhtUt6QeI3CZ4oA
9RwJkTHNLM+to+ssI9LqYhR3md4/Eh8kLFTySc0VlcANd1SzlhomAzeZIz2V0h7A
d1Xe+8e0oofKXd3h84WtmN0B4Pr8VDckDdtbSQI90l/OpdhkLrUPD+Kc/S6eloIa
A1yoc7rdr4uquQt8N37ZZ4JfS9kKD0aoDHlx1bUo92Rw5lKkVPM4KbpetC79WO9a
ek+afwk9I+1jQIGPI9uKKExP9SBVJG0fQE2ICwfrfC0xqDnZp74m61uvDUDqRqB4
lpNwi/2LT8IQsLpuC993npOd76cjmBTLlYQmqd/u+4ap7O5Dyd80/jpsL2Zr2ji9
78NHCLqINOQZJinaIeJHvdL1j0Asi75kP/0Wietmhexwne63K4mMXzR+rS0ed7Jw
4S7wswE7VjXvxBhwPMZ9sub6fAoT700nemIE1oa8lQhJ947KbmDlzzDdrGDjwrpV
n9FEM+OXR2vmJvdhli8rPToxTq52TdRVRPB7AURI97XFJip1VW3Bwd6PYT1VRcVw
9nRhUXxpTm8NqRcBPlh3
=BhXd
-----END PGP SIGNATURE-----

--fyA1p1RlO9nWxe3v--
