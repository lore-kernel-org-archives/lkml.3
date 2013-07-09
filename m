Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3GIMB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:01:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45239 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab3GIMBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:01:24 -0400
Date: Tue, 9 Jul 2013 15:01:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: host: Use usb_hcd_platform_shutdown() wherever
 possible
Message-ID: <20130709120108.GN5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373367529-13713-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mkHYMT4O8DyWoHkb"
Content-Disposition: inline
In-Reply-To: <1373367529-13713-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mkHYMT4O8DyWoHkb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 01:58:49PM +0300, Roger Quadros wrote:
> Most HCD drivers are doing the same thing in their ".shutdown" callback
> so it makes sense to use the generic usb_hcd_platform_shutdown()
> handler there.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--mkHYMT4O8DyWoHkb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2/uDAAoJEIaOsuA1yqREXl0P/0gsT7cHaD8Vnk2fSfmzE6m4
HqR9BXQMzEAXNV+9B98S9FHIE1gGYGAcTlmyHu8i0wR0OVournHoWlVIBIS1m12V
lcYGRsF4Vmq3CFPSAetePxkxLqkNaFsP7fkg9LjbYmTslfrNBtBCb8DYNBhwh3m+
To9krbAUfTZVWVrIEOB2d8qErolp5Uo+b/wQQ1C7X4AglTfLfoUYiYtr0QM962VW
LYpM6SBhyQnuU765p8hi9QiTM8aoa3SSu7LnKq/kn7PwusO/aw09ESXV8Bkn6/+q
zwZLJKv4jTv/euVeTOD0Pq9ILLygdNoyZQwjkGQXGfnLdRl1rHiSXRXm8kXwe9JT
whnHn1isInJNVDJwooVO63u/5WzL9H3VFlrOw10gNcvNo29fnmkEK7Yaf0Yzxk7H
sqUOsjq3Rw0a2tohCOOWyIe8ykTfv8WYz4eSs4HprDsN/reJ+BPTlHGXRTVOOh0D
6Z+tspQEaS1tLYdqsee2wFhGRSZcHH/uq8NdUisQYOBfvUmiHhfmJ+UJfZmAkuWW
jfAxEATdwLHEJollr6NP7v9S5/lkYlUfC0712VDyeYQg88PyzOyJK6NDySXbxxOt
4/x+fpNiJi8OsZGTNrg0yylDrwkrgQkOBF0591Bcos8LKGKm1lfYKFtE/Mq9HPA7
Jragvuowu7rFUm5KEHD6
=Bzpu
-----END PGP SIGNATURE-----

--mkHYMT4O8DyWoHkb--
