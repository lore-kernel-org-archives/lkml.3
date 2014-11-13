Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaKMMDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:03:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39856 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaKMMDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:03:40 -0500
Message-ID: <54649E0A.7030607@pengutronix.de>
Date: Thu, 13 Nov 2014 13:03:22 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
CC: "wg@grandegger.com" <wg@grandegger.com>, Michal Simek <michals@xilinx.com>,
        Soren Brinkmann <sorenb@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: Re: [PATCH] can: Fix bug in suspend/resume
References: <a44efc1fb0144cca9d0c4851cc51db25@BL2FFO11FD024.protection.gbl>	<546484D9.4030005@pengutronix.de>	<54648BF4.60007@pengutronix.de>	<9455da2b86c74d5aafe9bf118edec7bb@BN1AFFO11FD045.protection.gbl> <20141113123218.79850236@ipc1.ka-ro>
In-Reply-To: <20141113123218.79850236@ipc1.ka-ro>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4wE7Jg7KguPfsGsbBXRRgDfE747xg132x"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4wE7Jg7KguPfsGsbBXRRgDfE747xg132x
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/13/2014 12:32 PM, Lothar Wa=C3=9Fmann wrote:
>>>>  static int __maybe_unused xcan_suspend(struct device *dev)  {
>>>> -    struct platform_device *pdev =3D dev_get_drvdata(dev);
>>>> +    struct platform_device *pdev =3D container_of(dev,
>>>> +                    struct platform_device, dev);
>>>>      struct net_device *ndev =3D platform_get_drvdata(pdev);
>>>>      struct xcan_priv *priv =3D netdev_priv(ndev);
>>
> Why not simply:
> 	struct net_device *ndev =3D dev_get_drvdata(dev);
>=20
> There is no need for a struct platform_device* at all.

ACK

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4wE7Jg7KguPfsGsbBXRRgDfE747xg132x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZJ4KAAoJECte4hHFiupU718P/jAARGmiFL2vp3iAHwiDcj4V
e81t+DyNqBn2blQBvT61+XA6e8iAf9f5tsAzIyvAYMZiBi74b4S1cIl6AG3Re8Pq
QyDNkngyEWkxG7W+PdxDY6KBcHXJMCRH4Y3G3jYjIdk95QFrH3t1b0G4/Sq8tKqP
whI4hikmXzt2zG09Opc0D5zn/9Yv1PB1r+J0q0yM767F7FaI0lT2Bwwjb0b0tVbN
d+QJcGnj1OMapHFiAUSwRc8VqMGqCpguDEwbMjJJutIgpp0dcSL4Gk8j6iUwo2yF
MIqL2Rc1Hz5K5s3qJ7GJB5UU67SFkBwqUl4NgbNmdc7tOj2TmtsNtNHLGLBzqatC
cQgVz5AdVH1QsfNg+BgCUEJBfDcoRygDofTpnGLMWleVZ4CWJN9MWxAQc75k8HC+
E2eqs7vv2Gd0IJj/c1r7BvRK9BhlZXGa07YBSnbEGQ7706mk6fBw29MWvKOG5zmA
F/UScHHsBuKCmzLTuYhfJviZw5e1UTc1LBB7LBy7wKBWcb28ZmR1WZ2oPDk4OK2p
xusP7v6WeumzOzNLCpRGj2LCnrYht4ncV6+Jbu2cdFO8cdiszzCZDB8drlOI8sPC
Iagmfra7+/bA7B4t9YO0AOcE1e7KlmbVdeBQ0zVTH2Pacd5Z6coAsHyvmy+O57Cq
RRb5GEu/rOoc61v9T1SJ
=G+o9
-----END PGP SIGNATURE-----

--4wE7Jg7KguPfsGsbBXRRgDfE747xg132x--
