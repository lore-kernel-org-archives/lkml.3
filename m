Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3FARAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 13:00:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44894 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3FARAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 13:00:14 -0400
Date: Sat, 1 Jun 2013 19:59:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: Cocci spatch "ptr_ret.spatch"
Message-ID: <20130601165909.GB15095@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370080765.29224.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <1370080765.29224.38.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 01, 2013 at 11:59:25AM +0200, Thomas Meyer wrote:
>=20

-ENOLOG

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
> --- a/drivers/usb/gadget/f_subset.c
> +++ b/drivers/usb/gadget/f_subset.c
> @@ -274,7 +274,7 @@ static int geth_set_alt(struct usb_funct
>  	}
> =20
>  	net =3D gether_connect(&geth->port);
> -	return IS_ERR(net) ? PTR_ERR(net) : 0;
> +	return PTR_RET(net);
>  }
> =20
>  static void geth_disable(struct usb_function *f)
>=20
>=20

--=20
balbi

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRqihdAAoJEIaOsuA1yqREnbIP/3TFl/NdHVzlg8/81ZnH/3Kn
kD/r1hctvjpmXo0DnWnCSDDT1dWdt5P1BAXRfmb+PfIMHsSkddqsa1DonkQ0D4ZD
MeNNs20PjLsz9fKGywKDMs1C6m4gXjIqTzexGADIfddTK5InSjpvMWycViK8ytvk
3uPY78lvEUHv0hg7DIv70+x37JELWq9T/JLtdxDal7Z7oVqE5qHk9Bpxyagvn+bt
v/8G2DFABtKAUTWuEzG0DrysBdFcX/Ozy7o8B685T8/TLXePltNSQ5DOFB78a4sh
uCAhlkRIecCQcMrVucJtJwtOHmnkwPQ/a2zVx/9+IxeqoOkDEtqeitFUSsFuntel
IrNgOI/MeBi+GuUl6W7TgpgvuQ/XGBu+3iS+2aXxbpxyrZSpToQ/pyngMtJeonLb
p4RKzO+gfao2faJ+yo8i9W99FLWCmvxuP5IJFaTTP4LF8ud6/R51m+jve8gkLbln
LNpvOvkJ2OTjVA9kPi0Uf6jrP41t5AbasnZOr6gwbazWKpnTF0FsVkBqseYe6+IQ
6+SRwzwVD9mQbOaN+0cT0emCfe9BrrrIj8wnacA/mZBi8jWl+4k7BPs4xEEbnYCd
1izK0sN7Mi9gbAxZbZ4PkJINn7MXCSNMgvzDpHX0t7nEphs2QodRa+RKx4IOB5it
gUBZ1FhZODdJeTQT1CWu
=MWjp
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
