Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3GPME4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:04:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47455 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab3GPMEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:04:55 -0400
Date: Tue, 16 Jul 2013 15:04:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Federico Vaga <federico.vaga@gmail.com>
CC: Paul Zimmerman <paul.zimmerman@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: DWC2 and/or S3C-HSOTG for STA2X11 board
Message-ID: <20130716120425.GA32038@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <38175373.Cq6zxae9tO@harkonnen>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <38175373.Cq6zxae9tO@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 16, 2013 at 02:01:33PM +0200, Federico Vaga wrote:
> Hello,
>=20
> I have an x86 board made by STMicroelectronics (STA2X11) with the Synopsi=
s=20
> USB-OTG DesignWare 2 on it and connected through the PCI-e bus.
>=20
>=20
> I know that there are two drivers for the same controller:
>=20
>    (host)   drivers/staging/dwc2/*
>    (device) drivers/usb/gadget/s3c-hsotg.{c|h}
>=20
>=20
> So, at the moment I cannot have a board with both host/device working at =
the=20
> same time. I have to choose to use the block as device or host, right?
>=20
> I know that the plan is to merge the s3c-hsotg in the dwc2 driver=20
> (https://lwn.net/Articles/540283/). Are still accepted patch to s3c-hsotg=
? Or=20
> it is work in progress right now (soon), so it is better to wait after th=
e=20
> merge?
>=20
> In order to use the s3c-hsotg I must implement a PCI wrapper that uses th=
is=20
> driver. It will be accepted in the kernel even if it will be removed soon=
er or=20
> later because of the driver merge?

currently s3c-hsotg has too much knowledge of the Samsung platform. My
suggestion would be to help dwc2 get in better shape. It should be
rather easy to support your board since that already has a PCI wrapper
driver.

So, stick to host only for now, help clean up dwc2 and move it out of
staging, then later it should be fairly simple to merge the device side
in it.

my 2 cents

--=20
balbi

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5TbJAAoJEIaOsuA1yqRE37oP/ioHZXQLgifUOSSokOX2Q/q9
Pi4cyCM+zFriQwZ3b3ACLwLezq6zyHmtgUlF9DWpm6Ay5tyIXsUL7HFaukfVzPAY
RbMfr5NPI11fPKz3FsfLYfhhs3LZwoGRE/+vvtZySuvBDRWpCq7v3f8H1P6kcPJd
BqtUJ1rrqhCVh9+PxLJx12mY7tCKpALnpuiFhUHXK6UJDQSE1/WCGBIqzNDFQRen
/U+OOCVhU+kU9TEPy04QWtFl+vCsJyOPo8iLuDFstgPNxsWJivt3YP0CkXnZHmJr
KCRJlXcWnPWub1RDLcYkU7UGOBWrteBMzZ5sJ3MIwpbemKH6hKaw9sqnJOJ5I2/c
wPVPTa27MhweGRR+LcVGXpn35Pdy3BFqNlnoiiLRa+dQvsV5Sl5bQpDB3ZJeqYrS
qb5C1oXDYHZwZcPpp1dDt8cpILNkxnKkff/zpXxnMGswR2Kkpg18pGYwd/2MRLQb
JvnyUqxLPjzRmjSTRJdq4KMcijsG9oi517TRZmEdno0U4VUq0hh8jgoGLVKw4FSG
w7f0CNqEKwIrD5jWBytpxGBAEV6SmVm8e96/lKv1Eys/wl32EOwvb4NaAMYVN6nf
rLgKjeaOoZtoRGStadN2fFcPXIyADQS3afTN59oaSRsPuDTdsPOilkDS5hzKlmOg
XCQvZVCeTiGf/x6WegQ9
=c+JP
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
