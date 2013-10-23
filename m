Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3JWRoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:44:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46902 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3JWRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:44:14 -0400
Date: Wed, 23 Oct 2013 12:44:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCHv3 3/3] Input: twl4030-pwrbutton: simplify driver using
 devm_*
Message-ID: <20131023174419.GH25954@gimli>
Reply-To: <balbi@ti.com>
References: <1382546835-20212-1-git-send-email-sre@debian.org>
 <1382546835-20212-4-git-send-email-sre@debian.org>
 <20131023172524.GE24448@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9iyR+p8Z2cn535Lj"
Content-Disposition: inline
In-Reply-To: <20131023172524.GE24448@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9iyR+p8Z2cn535Lj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 08:25:24PM +0300, Aaro Koskinen wrote:
> Hi,
>=20
> On Wed, Oct 23, 2013 at 06:47:15PM +0200, Sebastian Reichel wrote:
> >  static int __exit twl4030_pwrbutton_remove(struct platform_device *pde=
v)
> >  {
> >  	struct input_dev *pwr =3D platform_get_drvdata(pdev);
> > -	int irq =3D platform_get_irq(pdev, 0);
> > =20
> > -	free_irq(irq, pwr);
> >  	input_unregister_device(pwr);
>=20
> The same bug still exists. You don't need to unregister manually any more,
> this whole function can be just reduced to "return 0;".

then it can be removed altogether, no ?

--=20
balbi

--9iyR+p8Z2cn535Lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSaArzAAoJEIaOsuA1yqREYOwP/3PVEzbBfW/1fQHrll8mKHHe
P2kmqyb5JwBIv89PwHVQ74gJYDKCU/p0gRMyywrYwUAT9mQ+77amtWV/1RXPdzRG
//UfSl4+s2gFmigk8aY/ob0JwYPWib+r+IaAb9P+0IX/OvlvhV6S0FQYc5PHIbuv
IdJ7FPsObQxD/VLpaN+7jzzcCuHX0Je4FATah/2XVbHSx7Fmt3ZN83Xd0Xb8f7T/
/8+ktign0YRgHYo4sJQrvO2NzIt0RL7xecjXIRvZRlqjT+G9hUDVNl0DQn15u6g6
58ALl2uRTPM4nEbYHcXDQPYDkQfwHwB1/udfjf8Ihuq7kqZUNfU5Pf2F0FR0OrIM
iFTVHHlBRPfdskcOPOmUr7brjElDhvW8B4yIwOEq/s8/9SdCrfkUviBKnfHI5FF2
lLFDZv1wtcxHvuf8ldoaueslc0gboKElQH7GdCdsumbgo21Z+rNTCRJEs8xWNE79
BS+uuModXMa7Iaa3qhlx0dr8Y6WBoXpIUay1f48n79ssVdoCbIuvG4csBsdgbg3H
ithAjwWNh/pkdVVgPEuVg/PVb8wNc6O4cf3DlJmVyqTTyqWp90W/ki0Yexhcmib/
NWuKH9yxPazLk3UwU8O3quTFnejzTpYjwQ6AO/sj+k8GbyEXctQwAHYEHRNkS+9v
N44VCo4YHWy14XD6wle7
=rUCi
-----END PGP SIGNATURE-----

--9iyR+p8Z2cn535Lj--
