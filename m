Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbbAFL1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:27:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAFL1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:27:07 -0500
Message-ID: <54ABC635.10702@pengutronix.de>
Date: Tue, 06 Jan 2015 12:25:41 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        Soren Brinkmann <sorenb@xilinx.com>
CC: "wg@grandegger.com" <wg@grandegger.com>, Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] can: Convert to runtime_pm
References: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl> <20141223224308.GC4611@xsjandreislx> <7324bcf422d141f0b09f0cc0e8352479@BN1BFFO11FD005.protection.gbl>
In-Reply-To: <7324bcf422d141f0b09f0cc0e8352479@BN1BFFO11FD005.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fBfQnPOe1AIHsx5CQ86ChmxNVmKfOR2CP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fBfQnPOe1AIHsx5CQ86ChmxNVmKfOR2CP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/06/2015 07:23 AM, Appana Durga Kedareswara Rao wrote:
> Hi Marc,
>=20
>         Could you please  provide your feedback on this patch ?
>=20
> @Soren : Will update the driver with your comments during next version =
of the patch.

Sure, I'll return from my season holidays and will be in the office
tomorrow.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--fBfQnPOe1AIHsx5CQ86ChmxNVmKfOR2CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUq8Y1AAoJECte4hHFiupUkuQP/1hG3v1b+yju6aUe5YL8DAjv
8vfb381nDBf+i8AFzgfUC9hOW+anp9+hvVnC/Gi0vWoTDiWRmuG9TMjMmF2eT7il
9pPztogWccRDm7dhkzCbvemDCvZkl94t8TcmVRJFhA02AXdOcurqaDIRbVnR51fY
V+E6XnQQmxAUtUB1s2iJrmTqVqBZY3inIosyCYunhux+b0zlBODWC/VotUP7uE9J
qqmxzAAJCpHDKYD5VzSAxQP1va8xSgIE26r28W4af6NRL8AyurpZPwQWB2Pr8DgS
RcEHnoEieYY2nMQCrYONL6kut8a9mgDIEDCRL6IyLmxAsYJxuRumRh0Am0riWvXq
T5MFCDq+k+um5Yj6cp49wPUH5nr1sYNdmTknD5tu7dIqoDToKLK+rmtKaV8FApb8
a+wIgEpVsRDgfXYP+oq5hYl43beh2YFcQ5Fcomb4GrmhY7uCp3Jau8hYRgrYv77a
/GH6g8lfC7iBv730Ties8ma/eD7xHdqJUEDCqh5XYSk5efik0Txl1vJFSCrO+NKV
fgo7onm3yKJHMTfeTaNgw327DBRTCfijevCdKfnvfw+vZ2RaMcxGGHbKaQ8TxQJO
RM+y9T66ScU0jliMecbiU94ssTchq6LUk/cDzj/NYnaz5aazSnNEPQ3rqBsk29hf
xqqkmviNL8dNCsBTvCgM
=dSPj
-----END PGP SIGNATURE-----

--fBfQnPOe1AIHsx5CQ86ChmxNVmKfOR2CP--
