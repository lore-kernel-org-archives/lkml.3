Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbbA1U0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:26:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49711 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbbA1U0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:26:44 -0500
Message-ID: <54C8F62D.6090909@pengutronix.de>
Date: Wed, 28 Jan 2015 15:46:05 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: Convert to runtime_pm
References: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
In-Reply-To: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="bJ1c6I79LNEDHDDmqjJAhXxnT89tQaGj7"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bJ1c6I79LNEDHDDmqjJAhXxnT89tQaGj7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/12/2015 04:04 PM, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the driver=
,
> Use the runtime_pm framework. This consolidates the actions for runtime=
 PM
> In the appropriate callbacks and makes the driver more readable and man=
tainable.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Changes for v5:
>  - Updated with the review comments.
>    Updated the remove fuction to use runtime_pm.
> Chnages for v4:
>  - Updated with the review comments.
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.

Any plans to submit a v6?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--bJ1c6I79LNEDHDDmqjJAhXxnT89tQaGj7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJUyPY0AAoJECte4hHFiupUC8kP/A1gg65BeJRx9hXfakGQm/Ks
M1KJpy4sRorbSLgdF1NI3EvaOJMptCnbWExPi+6yo7QvmJaiDAVxM5AiWoYvpyxt
Ly0BOy3koRudsYYcuQ+ULsiI7KakJ73Qzr9KSiii2SNHxyOdOue7G1JJ4Riazw26
fFZrVeSUgWSfABp23aaM1mUTi0xe1VUXWvWKqGPFIv+WVd5nYPb3NFpt6GjS6Bhj
zqki9Htr67w0IHokmzctFd2gkSSWdrrLWQqrMKD8NqnyD+yNitacEEY3jcEpRRBm
q7DnCiXq7lCvoV131moc2YJf/tab6ySKVMf3rZ6AU35DAysp9K+K1kAsVIofJzxt
3uOZoatkcNVHmXjkO2sCOSYTYeAxB4vYU8SQiG15NdnRxNUkvA1+YvPqtI0obwJz
E6tDS9zmGq+Qb2JmB/wELBUuRzyYaq8j4af0LMeoQLur89ZyxokDwpNIuC+yhHDG
hzVzAzIK1xjfB7BsvAow+Y4nlh7R+4eGvL01w8mdzbtfJTBzth+ai8ZpScsXsIRu
7+aE+Yun8s2xVYK5BAgjairAI3/1Nh2MydtUC6BpLsZGDxZXA23W1Lk4stcA7bz3
cqkipWobTWdLx7WH4WZX4vybHv3amZ4220C7HI6BPSxdFubEnI3/hh1kP8Y7oFjM
VsAMFnzXYmbqs8WQIEzk
=GIE6
-----END PGP SIGNATURE-----

--bJ1c6I79LNEDHDDmqjJAhXxnT89tQaGj7--
