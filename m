Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaEMIrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:47:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51821 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbaEMIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:47:13 -0400
Message-ID: <5371CD3A.9020500@pengutronix.de>
Date: Tue, 13 May 2014 09:43:54 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>, Jet Chen <jet.chen@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: [net] BUG: unable to handle kernel NULL pointer dereference at
 000000000000022f
References: <537188D4.6050201@intel.com> <5371AA32.6070407@hartkopp.net>
In-Reply-To: <5371AA32.6070407@hartkopp.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aE5Cpud0re1qwkow6nH8No27ccbAfE4wm"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aE5Cpud0re1qwkow6nH8No27ccbAfE4wm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/13/2014 07:14 AM, Oliver Hartkopp wrote:
> Hello Jet,
>=20
> this is likely not CAN related, as
>=20
> # CONFIG_CAN is not set
>=20
> and all the CAN changes introduced by Marc's merge are not even compile=
d in
> your setup.
>=20
> So I assume the issue somewhere in the netlink or ipv6 stuff (see commi=
t at
> the end.

Yes, I my merge is probably broken. That was an attempt to merge net
into net-next, but I'm going to ask David Miller to do so. As I'm going
to rebase this branch onto David's net-next (after the net merge), we
can ignore this for now.

Thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--aE5Cpud0re1qwkow6nH8No27ccbAfE4wm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEUEARECAAYFAlNxzToACgkQjTAFq1RaXHNFhgCePnlpFMg20DmQ41uY84kmf4dR
+W4AmL25rmtvz5Ukx1sawbuHARW9Wbw=
=+9h6
-----END PGP SIGNATURE-----

--aE5Cpud0re1qwkow6nH8No27ccbAfE4wm--
