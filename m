Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab3GYRvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:51:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35604 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab3GYRvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:51:38 -0400
Date: Thu, 25 Jul 2013 20:51:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <balbi@ti.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/9] Tegra USB cleanup series
Message-ID: <20130725175133.GM25415@radagast>
Reply-To: <balbi@ti.com>
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
 <51E485B8.5050502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wfe1KbQWcwuymTys"
Content-Disposition: inline
In-Reply-To: <51E485B8.5050502@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Wfe1KbQWcwuymTys
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 15, 2013 at 05:28:56PM -0600, Stephen Warren wrote:
> On 07/15/2013 01:53 PM, Tuomas Tynkkynen wrote:
> > Hi,
> >=20
> > Here's a V2 of the few cleanup patches for the Tegra USB drivers, to be=
 applied
> > on top of Mikko's two patch sets. It mostly deals with removing all usa=
ge of
> > platform data and using standard helpers and enums instead of Tegra-spe=
cific
> > ones.
>=20
> The series,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
>=20
> ... although I think you'll have to wait until Mikko's two series are
> applied, since this is based on them. I'll finalize the patch
> dependencies for the Tegra DT changes in Mikko's series tomorrow.

series doesn't apply on top of Mikko's patches. Please rebase on my
testing branch on kernel.org.

When resending, please put Stephen's reviewed-by, tested-by and acked-by
in the patches to make my life a little easier :-)

--=20
balbi

--Wfe1KbQWcwuymTys
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8WWlAAoJEIaOsuA1yqREllMP/AzGBr3mzMnKBZcl0dKOY4O+
eVWrXl/zvD4OKP9/W+R8wI3gY1gMIWWJKTCm6G2DvygBeqeTBc0+ori7K/O1MSIg
ziVU8pALHWNSV0y4SD9ns78SAicsxNeECwt48FN6s5QwtWgv7V7bNUou7UarUe/p
aSiPnC3uUS+8hO5W4cQotco+4mFvPWLef57ErlmEsZFZd4dzbHZXXLQA0MxhV3X/
7KeVo8N6yr1NNSibWDZuCPoH3TESN+l6l2DbToUi3wHeVClheUnbT0iOpTzZz0ty
XKHvSeqTl334HQdoZ9tf9KThcPnk2LBTetMV7SVQmB2CypsyxvSR0I8mVMtaRf0b
TEciEVAPbSPyNiC2kv8N3F36uEWc45QHCT7KLAmYWdq8cormiACsLURVUnNNiXn3
2BYzecsTPenNYN8opbyFO1ZO/zmKXJEjB/gQRDFhFyNmTN4hamTnaOiRNSm5jhXi
ISbD8vZoPqaGKdBUeKH8ZCyXpQBKEj8h4z99vYNaZybuD6oFA8L0FVb+dLIzqIMV
SYzvYCv3a+cHebPTX1iSuOkUNndptrdsHB7Ufb56tddbw8N35iWucbMKdoldbcNd
k7zqt9P6QxdsjNIBJybLMU59KcZqs82Uyx+4ODTn+tHVb6pT02plcenof33um4tP
PDNJns6j9tMCzQmmFA1/
=px+y
-----END PGP SIGNATURE-----

--Wfe1KbQWcwuymTys--
