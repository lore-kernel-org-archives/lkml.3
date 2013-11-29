Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3K2MDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:03:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3K2MDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:03:17 -0500
Message-ID: <52988266.2020807@pengutronix.de>
Date: Fri, 29 Nov 2013 13:02:46 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] w1: mxc_w1: Remove unused field "clkdiv" from private
 structure
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru> <52987EB1.4010503@pengutronix.de> <1385726217.626946686@f256.i.mail.ru>
In-Reply-To: <1385726217.626946686@f256.i.mail.ru>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="w04R0I4cK0aRkAfNKsncoaaOneBjdf0fu"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w04R0I4cK0aRkAfNKsncoaaOneBjdf0fu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/29/2013 12:56 PM, Alexander Shiyan wrote:
>> On 11/29/2013 12:39 PM, Alexander Shiyan wrote:
>>> Private field "clkdiv" is not used outside "probe", so there are
>>> no reason to keep it in driver.
>>
>> Where's the corresponding clk_disable_unprepare()?
>=20
> I do not see any relation "clk_disable_unprepare" with this patch.

Yes right, sorry for the noise.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--w04R0I4cK0aRkAfNKsncoaaOneBjdf0fu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlKYgmYACgkQjTAFq1RaXHN4OQCePKykiRqlfnYsrJzu/CagCYrR
x/YAoJidxyIskMyJvBcK/+nk231lciH1
=zYN5
-----END PGP SIGNATURE-----

--w04R0I4cK0aRkAfNKsncoaaOneBjdf0fu--
