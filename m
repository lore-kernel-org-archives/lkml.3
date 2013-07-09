Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3GIMEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:04:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34979 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3GIMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:04:34 -0400
Date: Tue, 9 Jul 2013 15:03:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
Message-ID: <20130709120354.GP5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
 <20130709102022.GH5552@arwen.pp.htv.fi>
 <51DBF23F.20103@ti.com>
 <20130709112751.GI5552@arwen.pp.htv.fi>
 <51DBF98B.1050104@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjOMJDssiV0CZSJH"
Content-Disposition: inline
In-Reply-To: <51DBF98B.1050104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tjOMJDssiV0CZSJH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 09, 2013 at 05:22:43PM +0530, George Cherian wrote:
> >>>Another thing: am437x has 4 instances of this IP, why are you adding
> >>>only one ?
> >>AM437x has got only 2 instances. I have verified only one on HAPS so
> >>adding only one.
> >weird, on my TRM I see for dwc3 but 2 PHYs.
>=20
> Please confirm whether you are looking at am437x TRM or dra7x TRM?
> dra7x has 4 dwc3 and 2 internal  phys and 2 external phys

guilty as charged :-)

> >>>And why aren't you pasing the PHY nodes here ? The device
> >>>won't work without its PHYs.
> >>Yes true, again in HAPS I  didnt have any PHY configuration to be done.
> >alright, but we should still pass the PHY right ? once silicon comes,
> >we want this to work without any further changers.
>=20
> okay will add phy nodes and 2 instances of dwc3.

thanks

--=20
balbi

--tjOMJDssiV0CZSJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2/wpAAoJEIaOsuA1yqRE+u8P/i9RlFNpp8aZoU5wgz1njZXm
SKe0j03SMLzX1HX5VeNu+Y0kzVBs3cxfRXTwwY1f1TAlsB15xSNm/ZiORfpgXXWE
516fxrJRsgwP7ZUW/I35iBh5NP0XOqZYv8p3rW5k52ojkc5RU8MrDpLntVB0TziA
XqmWUhEt8bjSeCLux8yPRYCYMmaE2WH5w/583eSQlA/yfI7IX7ciYt/sKOKv2Hu8
udRBoRZNNOBmnOKY9Mh5Lsh7b/BC94Nz3MdHLiZRsSgp1XwzyFvK0AiJJEj5CC4w
G0syL74R3fEJdbL511yhWPhGzQanlsHvlNFVwggEnsKHp+rGUL9xjf2N07lXTF3B
BcIkkaegykrKwfMEXWzx7Sl8aeagyWXjRylLHGcwEkCyhfBzs3+cu27BpnZtUu5k
5mHHVZ1eHcWk+kGoZMGDsVJsDBjSBI5nHK9EvUIpcrMqjyYqmQgvGpFg5m1odDur
+Ii0YI1oI5OG/H6zn5PJGspOGRzhV6Xbe7ePNsTw/Cbq/NFkeFBCHC4+GpzkLqU0
tlB2X620+YvFDFbZjyX3ugJLVrqWQYHwgAbJch8GKJMLa3hsMRcvkZ/ww/gf4j5Q
b73ql+Al7lNnThZuVgshBjHVAMizTgySSZWeX6tWPQXSxEu1cYzdcKj/jDofVe6p
pQVIPXxAFWS1eL1N93Gw
=DMc7
-----END PGP SIGNATURE-----

--tjOMJDssiV0CZSJH--
