Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3JVIJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:09:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36864 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3JVIJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:09:49 -0400
Message-ID: <526512DE.8000005@pengutronix.de>
Date: Mon, 21 Oct 2013 13:41:18 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        =?UTF-8?B?TG90aGFyIFdh?= =?UTF-8?B?w59tYW5u?= 
	<LW@KARO-electronics.de>
Subject: Re: [PATCH 3.2 094/149] can: flexcan: fix flexcan_chip_start() on
 imx6
References: <lsq.1382345188.205668698@decadent.org.uk> <87mwm27tf6.fsf@canonical.com>
In-Reply-To: <87mwm27tf6.fsf@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LwBH1WNDpigJU3WDndtioQuaxTm6fIfdT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LwBH1WNDpigJU3WDndtioQuaxTm6fIfdT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/21/2013 01:30 PM, Luis Henriques wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
>> 3.2.52-rc1 review patch.  If anyone has any objections, please let me =
know.
>=20
> Looks like this patch introduces a regression.  According to Marc, the

yes

> fix is on its way into mainline ("can: flexcan: flexcan_chip_start:
> fix regression, mark one MB for TX and abort pending TX"), although I
> haven't seen it in netdev git repo.

I see it on "net/master", though.

d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
        for TX and abort pending TX

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--LwBH1WNDpigJU3WDndtioQuaxTm6fIfdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJlEt4ACgkQjTAFq1RaXHP6zACfaAUtP7R1geGWLsNreDvwut59
zMcAn3FhM520wvcXQqndFfKAnRQqKjkl
=+bKR
-----END PGP SIGNATURE-----

--LwBH1WNDpigJU3WDndtioQuaxTm6fIfdT--
