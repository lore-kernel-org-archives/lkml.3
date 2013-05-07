Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab3EGJTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:19:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3EGJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:19:01 -0400
Message-ID: <5188C6FD.9010903@pengutronix.de>
Date: Tue, 07 May 2013 11:18:53 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org
Subject: Re: [PATCH, RFC 01/22] can: move CONFIG_HAVE_CAN_FLEXCAN out of CAN_DEV
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-2-git-send-email-arnd@arndb.de> <5183892B.8020400@pengutronix.de> <201305031724.15584.arnd@arndb.de>
In-Reply-To: <201305031724.15584.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HNSPVJXIPHKTIRHBFOQQ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HNSPVJXIPHKTIRHBFOQQ
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/03/2013 05:24 PM, Arnd Bergmann wrote:
> On Friday 03 May 2013, Marc Kleine-Budde wrote:
>> On 05/02/2013 05:16 PM, Arnd Bergmann wrote:
>>> CONFIG_HAVE_CAN_FLEXCAN is a silect symbol that is meant to be select=
ed
>>> by platforms that support this driver, but that is not possible witho=
ut
>>> also selecting CAN_DEV, unless we move it out of the "if CAN_DEV"
>>> section of the Kconfig file.
>>>
>>> warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 &&
>>>  IMX_HAVE_PLATFORM_FLEXCAN && SOC_IMX53 && SOC_IMX6Q) selects HAVE_CA=
N_FLEXCAN
>>>  which has unmet direct dependencies (NET && CAN && CAN_DEV)
>>
>> With the advent of multi platform kernels I like to get rid of
>> HAVE_CAN_FLEXCAN completely.
>=20
> Yes, good idea. Are there any other dependencies we need to add then?
> I assume FLEXCAN needs to depend on HAS_IOMEM and OF at least, but
> there might be more.

The driver compiles (tested on SH and blacksfin) and works without
CONFIG_OF (on non DT arm platforms).

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2HNSPVJXIPHKTIRHBFOQQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGIxv0ACgkQjTAFq1RaXHO3bQCfZP4g8Y+lK/pbe8e8m9gT4ixL
zbQAn1H1HTr0TmnFlfGJeTKy8MAPJa8Z
=37mW
-----END PGP SIGNATURE-----

------enig2HNSPVJXIPHKTIRHBFOQQ--
