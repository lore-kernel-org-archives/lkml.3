Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaAaMvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:51:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaAaMvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:51:24 -0500
Message-ID: <52EB9C48.3010205@pengutronix.de>
Date: Fri, 31 Jan 2014 13:51:20 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: florian.vaussard@epfl.ch, Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>
Subject: Re: [PATCH v2 4/6] can: sja1000: fuse of_platform into platform
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-5-git-send-email-florian.vaussard@epfl.ch> <52EB9824.2010703@pengutronix.de> <52EB9AEA.4010503@epfl.ch> <52EB9BE1.6060407@pengutronix.de>
In-Reply-To: <52EB9BE1.6060407@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G3WbmE1tfU14Xlu8Q7VKGvILWfQnxEvT2"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G3WbmE1tfU14Xlu8Q7VKGvILWfQnxEvT2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 01:49 PM, Marc Kleine-Budde wrote:
> On 01/31/2014 01:45 PM, Florian Vaussard wrote:
>> Hello Marc,
>>
>> On 01/31/2014 01:33 PM, Marc Kleine-Budde wrote:
>>> On 01/31/2014 11:35 AM, Florian Vaussard wrote:
>>>> The OpenFirmware probe can be merged into the standard platform
>>>> probe to leverage common code.
>>>
>>> Good work, as we want to replace the existing driver, I'm quite picky=
 on
>>> this patch, see more comments inline.
>>>
>>> Please don't delete of of_platform driver, yet.
>>>
>>
>> Do you have any reason for not deleting of_platform? After this patch,=

>> we will have duplicated functionalities, this may be misleading for
>> other people.
>=20
> Okay.
> IIRC there _was_ a problem on sparc, it _should_ be fixed now, better
> get a Tested-by from Andreas (Cc'ed).

You have to use irq_of_parse_and_map() on sparc, but your patches does th=
is.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--G3WbmE1tfU14Xlu8Q7VKGvILWfQnxEvT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrnEgACgkQjTAFq1RaXHOoIwCeJK1N/EsJECovizbgHg9jpXW8
1kcAnRIUkf8FLBMKtW8KCDCwazIXOLXf
=IM8k
-----END PGP SIGNATURE-----

--G3WbmE1tfU14Xlu8Q7VKGvILWfQnxEvT2--
