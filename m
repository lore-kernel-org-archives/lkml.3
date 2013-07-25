Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3GYOWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:22:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52117 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3GYOWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:22:14 -0400
Date: Thu, 25 Jul 2013 17:22:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] usb: phy: msm: Lindent the code
Message-ID: <20130725142208.GC16106@radagast>
Reply-To: <balbi@ti.com>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
 <1372087664-26396-8-git-send-email-iivanov@mm-sol.com>
 <20130724122253.GC17962@radagast>
 <1374759651.1956.29.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <1374759651.1956.29.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 04:40:51PM +0300, Ivan T. Ivanov wrote:
> > > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-=
usb.c
> > > index 6d05085..111f454 100644
> > > --- a/drivers/usb/phy/phy-msm-usb.c
> > > +++ b/drivers/usb/phy/phy-msm-usb.c
> > > @@ -64,8 +64,8 @@ static int msm_hsusb_init_vddcx(struct msm_otg *mot=
g, int init)
> > > =20
> > >  	if (init) {
> > >  		ret =3D regulator_set_voltage(motg->vddcx,
> > > -				USB_PHY_VDD_DIG_VOL_MIN,
> > > -				USB_PHY_VDD_DIG_VOL_MAX);
> > > +					    USB_PHY_VDD_DIG_VOL_MIN,
> > > +					    USB_PHY_VDD_DIG_VOL_MAX);
> >=20
> > like here, what's the point ?
>=20
> It makes indentation the same like the majority of the code.
> I could drop this patch if you like.

yeah, I don't think it's worth to have this patch. Just looked at the
driver and, at least to my eyes, it didn't look all that bad. Matter of
taste though

--=20
balbi

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8TSQAAoJEIaOsuA1yqRE6PgQAJHOjd0x1C1cZBSLMLLsgR76
t4sBqYzBuXHlxUjQg9CaMUWl98XGpvoO0p1yNxNN1ePOP1/T6Yf1IigYXhKV04z/
Go+eidRPziNmdkEmJ3G6KUicSUETLWeBmRDVS1McD2XghmrpusJ5KobocODXPHXu
Wv4A/+c55V/HnPZYFZOBKPrudVtNzQXVHu3r4k41TIKEQBnwaDAlJuezbGF0eo1P
GLjyOsG+KD/0bfTnPr/eL+obLDTMXkx5CDMtppRZrypMo+/Qpsg3l0h5BviNOlo9
mvl/StvKKlw/u4C3rJaDZ1IHl2D+KuuE66clDbvxr+oipTitM6/zA1VPl2a1M+o5
6KJEYrYd2a3lvuoodWxhfKOgY5EBaogq0FlO4Ga7y54prDaaaOaqZd6vaw6qeif9
xT/+WsuAYhfJtvima/RjqEtbGfJvos9Pt4Zu6VsphjMMDHFAH9IrRYYSwOhKqOfh
r73vR8c3AQ4adRHTQXyMznUyfVdOUK09Yymi/pxPUhq7EWGQvyrHU0G2p7pX1bpM
0Hg4AICDI/5eWNCCglglK9i/VvPxW+YhqhwStcG5ogZUlULHHbIJ8ce5D8jf8ehY
EXGEfouJRtWeD1J8ss7JiFyZf56KTHUM5Qqc743LFUUnx8SmiVPD2vzInsKO5eQA
/wD4vLUFDn66PHa0XFhT
=mbkf
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
