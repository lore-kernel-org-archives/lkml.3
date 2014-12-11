Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbaLKWlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:41:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902AbaLKWlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:41:11 -0500
Date: Thu, 11 Dec 2014 23:41:04 +0100
From: Sebastian Reichel <sre@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20141211224104.GA11666@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20141211215943.4127.24792.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 12, 2014 at 08:59:44AM +1100, NeilBrown wrote:
> A "tty slave" is a device connected via UART.
> It may need a driver to, for example, power the device on
> when the tty is opened, and power it off when the tty
> is released.
>=20
> A "tty slave" is a platform device which is declared as a
> child of the uart in device-tree:
>=20
> &uart1 {
> 	bluetooth {
> 		compatible =3D "tty,regulator";
> 		vdd-supply =3D <&vaux4>;
> 	};
> };
>=20
> runtime power management is used to power-up the device
> on tty_open() and  power-down on tty_release().
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>

FWIW:

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUih19AAoJENju1/PIO/qa5oEP/RY34vy8VJRE3Fez7FB9zX+k
GhEmT+Mzn0XHfsYWclVNCAj/1roznRwpw+Gw1QmAW8Z26h/ab9CrIjQpu0idSEMA
rhRJSL+a/+TwfdQYc7wPFCqlcCia+zXzrgTJLteWkoN+f8N3YyFILQpZtun9UKb2
J2tkcLu9lU/B2tl8FJ1Oi5yYD4RpZ9oFqiMA/AQM6WbGcmKFK04SY+Pv82fhCtm9
asTHv/Ao95jUIwZsnp4rUumIwxP83+yhJT9JnF1ttLj/OPTcxJOGyQDTKLoqgoVI
7aIZ3Tmx4P/idy95fd60P4bkCa6jgKEjlxgKYe4QCnb2UiiHfWyVQoHxVm5pgM0d
hGdtwF2JXvJ3Hom8mDMw3w3yQ2QoYOg7sq9/dpMSZqX1zym0waJmiVFzz26PWY+c
Y6SZQCzwtEfY9Ncs96ZYqlZMnetCkCPbkjwVDfTigJpGLGKIuL7SIL0gyU2asO82
7XP2y7+Q+/VjGQmle74K0lG3lmnZ5Bk6k84vuXCSxPJxf1+os2/59394RtCWBkTf
omiRExXkGtKDtFqGvnfTSM9BUd3HvwP011ra3R81+nzaQIMQDGtosleHqPHuKZ06
PEQ/KJRHAHY3nI2PYKZNDoWIvxkGnZeXw/8cfHES8arA/BEVhnzkyeW7V+uJYXCh
aTI3/pxM7Wt55xIRf3iK
=t1+L
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
