Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab3GXEen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:34:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743Ab3GXEel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:34:41 -0400
Message-ID: <1374640475.18653.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: request for stable inclusion
From: Ben Hutchings <ben@decadent.org.uk>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Liang Li <liang.li@windriver.com>, Li Zefan <lizefan@huawei.com>
Date: Wed, 24 Jul 2013 05:34:35 +0100
In-Reply-To: <51CD518B.2050106@huawei.com>
References: <51CD518B.2050106@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-arsbCk4Iqh15r2Ffq/+8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-arsbCk4Iqh15r2Ffq/+8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-06-28 at 17:04 +0800, Yijing Wang wrote:
> Hi Greg, Jiri or Liang Li
>=20
> 384e301e3519599b000c1a2ecd938b533fc15d85
> pch_uart: fix a deadlock when pch_uart as console
>=20
> This looks applicable to stable-3.4, and it
> was built successful for me. What do you think?

I've queued this up for 3.2 as well, thanks.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-arsbCk4Iqh15r2Ffq/+8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUe9ZW+e/yOyVhhEJAQpspg//UdXL76i6pXD2iae4kyFKQLc1XXqE5Wgf
ESsw80FyAbKYO1vadtgEknPMBqSkI5wO3V6251h4i0duqGKYCb9r0OPTtVTudYn8
bBe/EEJhHjxMAcuqMTtJ/4v/8iP39haq4Vz/I2evs1cl7Zbx7df3ueeIbJ6CKA2h
doqWfwbCIzRfKBW6heWHEuCe+iU02DsBHCmisABH30+3g/dBqTOyDqcuoHtSkfcN
f2kNf28EDSsbyHK1QM6VtB39p88PmAQ+rF9/4gls58yHbn5j6DwV4WjWVjqQ0xmE
Q5zLRhEIADcAVLI5v++RaA/0pYnjHpzDUAHVd/iJJWkcd+a56bqaNrtfDHL2X47n
2FyamEFvZJ6B2hRzyiswi+wEMpSD8m8dAPwBsPDgPM0HzjHlSprbmVi89YlupjVv
s+zp9lpL4f4rzTOBx/1f1ePc4VYthgkaN6B0u1Ikz5kGVtcDtzcXK3rLBx5oVxlf
NF61F+ND3Fo2K4fMqNoWPPwswwt0+Oh5tfH3DZ8DklH2zKIPJuB2MytjbBfvypV+
IfJcM/gY2HXhBhdL22C6qnYWbZufSHlTcFPvotkeGmPIP2Cjk/B3et9jCrOfL8Kq
2XY2mzEGTmDj1p59U8rAvG8adquFMq36uS5ceOs6lkz3PbsmMqDcqvTiK5BVmPlf
EjI2H3isjjk=
=tLJO
-----END PGP SIGNATURE-----

--=-arsbCk4Iqh15r2Ffq/+8--
