Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaEULhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:37:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35712 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEULhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:37:41 -0400
Message-ID: <537C8FEF.9040407@pengutronix.de>
Date: Wed, 21 May 2014 13:37:19 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/2] can: xilinx CAN controller support.
References: <30fc07d6-4404-4745-8c03-1c5ae775e4f1@BY2FFO11FD047.protection.gbl> <537C8E00.404@pengutronix.de> <72e9a444-0de4-42ce-a9d3-ee247948f0e6@BN1AFFO11FD030.protection.gbl>
In-Reply-To: <72e9a444-0de4-42ce-a9d3-ee247948f0e6@BN1AFFO11FD030.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x0HU5o4hLwFs8FPO0rS0R6LjXcTf4L5NT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x0HU5o4hLwFs8FPO0rS0R6LjXcTf4L5NT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/21/2014 01:32 PM, Appana Durga Kedareswara Rao wrote:
> Hi Marc,
>=20
>         Yes for DT-bindings Rob already had given ack.
> Sorry I forgot to add the Acked-by line in that patch.

The DT patch didn't make it to the linux-can mailinglist, can you please
resend.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--x0HU5o4hLwFs8FPO0rS0R6LjXcTf4L5NT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlN8j+8ACgkQjTAFq1RaXHNhjACfXprc42pB8630z28BVmUXeyc4
a88An2A49bIxFhk1YYapGpJI2Rby73L2
=vvUR
-----END PGP SIGNATURE-----

--x0HU5o4hLwFs8FPO0rS0R6LjXcTf4L5NT--
