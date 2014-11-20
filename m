Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaKTTvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:51:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbaKTTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:51:05 -0500
Date: Thu, 20 Nov 2014 13:50:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <ronald.wahl@raritan.com>,
        Felipe Balbi <balbi@ti.com>, <stable@vger.kernel.org>
Subject: Re: [RESEND PATCH] usb: gadget: at91_udc: move prepare clk into
 process context
Message-ID: <20141120195049.GF23217@saruman>
Reply-To: <balbi@ti.com>
References: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 04:37:27PM +0100, Nicolas Ferre wrote:
> From: Ronald Wahl <ronald.wahl@raritan.com>
>=20
> Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91_udc:
> prepare clk before calling enable) added clock preparation in interrupt
> context. This is not allowed as it might sleep. Also setting the clock
> rate is unsafe to call from there for the same reason. Move clock
> preparation and setting clock rate into process context (at91udc_probe).
>=20
> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: <stable@vger.kernel.org> # v3.17+
> ---
> Hi Felipe,
>=20
> I forgot to answer you on this patch. So I resend it now with the proper
> "stable" tag. You can also queue it during this -rc phase if you feel it =
is
> still possible.

I think it's late for v3.18, so it'll go on v3.19 and get backported to
3.17 and 3.18. Sorry :-s

cheers

--=20
balbi

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbkYZAAoJEIaOsuA1yqRE+eUP/RW5VYQlwQvLDlsS4lySmy7h
XD1B1vRfZUNBjP+FtxAJHcsep5cRlE3KXY3L1KNuuHzUP1TVB//bPwx/QGMUIenm
1hhryonrsiFDmPRMX5BQ/Dj30UxSJ/q6mAub7yj0KBO9ikagkRUhMmO5f/xHJzky
pB3Ebla5n2+CxribckC/idGdmchrgnWUCANtl00kDS9jklyl1x7+EThbXLv5YSKS
sV/5KUjw1K7gTgYPFBegM732MNGr/5rtnL6C+yibAeBJLIkZ3EIgYMl6TrRqOJ7Q
9EdFMyExLD2kT9tSfhQOdBe1phVmx4GmQ4rriXym06COuW8sEGHFPEjPwV5KPv/n
gbCTxDdCC89cf6dMZy+3gam1v2y+6mvpOmK3HgCgXkZPvBKol4aqjld+aAPIdcFe
9I47e6sh0O3L74Oli5/IJTfZMc0/YbmmwSrtwXvt9Ck32/V657AGgCkAeqUnhD1r
+fii9jA5D7yw3AnYdugZjMIYG365i7ZMWp8SrqOVdpHkehP3Hd2Z3TcKMsiw1Xov
NJDV8nQiF7egvpKxXr/ghcvJr10331GRiI5grwuL6R90vgHLW5AU0As1M/yRYpgk
tLUqSFQt2sxWzOV+t8NZUBeXIVqsai8zBWKujZxMTh23kN8UT/6hqcyQ/Q9UTz+v
Sl91kn/1QBDRnBkffgxw
=lq3S
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
