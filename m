Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbaKRPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:25:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45843 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029AbaKRPZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:25:55 -0500
Date: Tue, 18 Nov 2014 09:25:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 driver-core tree
Message-ID: <20141118152531.GD8223@saruman>
Reply-To: <balbi@ti.com>
References: <20141118181222.451b84d1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Content-Disposition: inline
In-Reply-To: <20141118181222.451b84d1@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 18, 2014 at 06:12:22PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/dwc2/gadget.c between commit 7c3e90537b74 ("usb: dwc2: drop
> owner assignment from platform_drivers") from the driver-core tree and

why is that commit in the driver-core tree ? It wasn't even acked by
Paul Z. It wasn't sent to linux-usb either.

Sure, it's minimal, but I'd expect a little cordiality in Ccing driver
maintainers ;-)

Anyway, thanks for fixing it all up Stephen.

--=20
balbi

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa2TrAAoJEIaOsuA1yqRETGcP/1oEHBC2my4YUo4srN+0k+du
A6TegqlON6AKZQyWkCh0RfwLbMR6A5dpBvgnE9h2uu7zfoGHJOI4qo2Lqs329Rad
KR3xkxWCSda3KJiuq3/A9OkJAqB5coJs5fH4R2c/aThxjn/3I9KIGXMBovfMj3l0
9qmbip8fWTse1w8QkFDYokmzIiNOqol6tjnoWInm6V4oPWIY1h3V2VQiWLJGaSaW
OgF+rqqvMrJF9VDW0TdgpL4qcOMW1xkEQZejSUzKO0sN1tQB9CdHUjcWHDlY1r0I
+hfjVSQ9mzagrRpPszJzQJDgVUgekm9PIkkpcP66KzZ4DMdHuz6zwtS+MlItjOR+
bI6KfltKdBAtsG8sTwU8XFzqcriw2+cpHvDCJbgY4wxeITivoQDSXC6AVUg21Kuc
YDFXvBKWIdZz0D0/gzbvLcUaDM1tErvt4TK+LN2pPPuVejIZb7SC04wZOkLiaoRH
mSPQdWKVZdNU+ylk2VGp7XVLvIon1IaKnDfTLMRNZVlvy+2Qp2CGirnr2ziz+zuR
e/ulZft9WkpHrrfmCWRDMiXlyClk8FHY2EdP2+3xDf9NvHEJ3YPP/RKg5c9IVGN1
RujDV5SZH5dd9ta6lVuvWcWF2Iwx5MUVQhMh9LAhrK6DWEid5Sd3OgROyOpQBA5F
iyrZ02zUkw9W4L5FHZ1b
=9FlY
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--
