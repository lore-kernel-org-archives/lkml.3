Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3K2Lri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:47:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35026 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3K2Lrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:47:35 -0500
Message-ID: <52987EB1.4010503@pengutronix.de>
Date: Fri, 29 Nov 2013 12:46:57 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] w1: mxc_w1: Remove unused field "clkdiv" from private
 structure
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RnIP48KFLtteOUpbDQPVM22MltVFjU4U1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RnIP48KFLtteOUpbDQPVM22MltVFjU4U1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/29/2013 12:39 PM, Alexander Shiyan wrote:
> Private field "clkdiv" is not used outside "probe", so there are
> no reason to keep it in driver.

Where's the corresponding clk_disable_unprepare()?

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--RnIP48KFLtteOUpbDQPVM22MltVFjU4U1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlKYfr0ACgkQjTAFq1RaXHMfDwCggav6cagW8OkZoPVmP1WFA96Z
J40AoJGRHA4b0qlQPysvhqrS9S8AtzD4
=C+0Z
-----END PGP SIGNATURE-----

--RnIP48KFLtteOUpbDQPVM22MltVFjU4U1--
