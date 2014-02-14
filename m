Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaBNJQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:16:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42304 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBNJQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:16:47 -0500
Message-ID: <52FDDEE4.9060902@pengutronix.de>
Date: Fri, 14 Feb 2014 10:16:20 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v2] can: xilinx CAN controller support.
References: <\> <0dc128ac-e5cd-47bd-9ab1-3a545c3e2043@CO9EHSMHS012.ehs.local> <52FD1B16.6020600@pengutronix.de> <52FDD9FE.8040908@monstr.eu> <52FDDC24.8070805@pengutronix.de> <52FDDE30.8020405@monstr.eu>
In-Reply-To: <52FDDE30.8020405@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4UQTvQD5XCcNvDjoJ5wUCVPt9UOHhh50p"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4UQTvQD5XCcNvDjoJ5wUCVPt9UOHhh50p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/14/2014 10:13 AM, Michal Simek wrote:
>>> That's not entirely truth. If you look at Microblaze then you will se=
e
>>> that Microblaze can be BE and LE.
>>> There is just missing endian detection which we will add to the next =
version.
>>
>> As far as I know the endianess of the kernel is fixed and known during=

>> compile time. Correct me if I'm wrong. So there is no need for a runti=
me
>> detection of the endianess and so no need for {read,write}_reg functio=
n
>> pointers.
>=20
> Endianess of the kernel is fixed and know during compile time
> but what it is not fixed is endianess of that IP at compile time.
>=20
> On fpga you can use bridges, partial reconfiguration, etc where
> the only solution which is run-time endian detection via registers.
>=20
> For example: drivers/block/xsysace.c, drivers/spi/spi-xilinx.c, etc

Okay, now I get it. You can make it more complex then it used to be :D

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4UQTvQD5XCcNvDjoJ5wUCVPt9UOHhh50p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlL93uQACgkQjTAFq1RaXHM5nwCggs0uUUYPbJ19vDd7HKsWoy6/
E5QAn1RTNztWr/e94iUSTdzPUSw+Th9Y
=v8+D
-----END PGP SIGNATURE-----

--4UQTvQD5XCcNvDjoJ5wUCVPt9UOHhh50p--
