Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3BEJck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51675 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3BEJce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:34 -0500
Date: Tue, 5 Feb 2013 11:32:23 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 20/30] ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
Message-ID: <20130205093223.GC32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-21-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kJMkLA1uPhjFFA+D"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-21-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kJMkLA1uPhjFFA+D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:21PM +0200, Roger Quadros wrote:
> Add 2 platform devices for 'nop-usb-xceiv'. These will be used
> as PHYs for HS USB ports 1 and 2 so provide binding information
> for them.
>=20
> Model RESET for HS USB Ports 1 and 2 as GPIO fixed regulators and
> link them to the 2 PHYs we just created.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--kJMkLA1uPhjFFA+D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENGnAAoJEIaOsuA1yqREaAoP/ijltRTmXnLBy2i2QjK76vcz
ec3nQ3B7rH2bqy7r+MfPlbEHeePdd+7Gls+Mnc38+DnRagrpDFE/47vxL6vnpn9F
EapA4eMSwFnfaVB9hJ7YrzKigtXzepPf59id4dfP4QyjIFbvciTHlf7mh+8b+IfQ
x9K8E5wpdzGK5Hl29qIKivLd43gW4kJxVp8hBCOu3Zf5vqT2B1nFvtvv0iNn3pTb
Utb26kYb1r6aCV1EWGwb915d96fytwaB9KfhBggJ+uqZkyUNvIQ/guVyprjsRVH8
mBqcyKWa3F833sMvadSbjOXRdd22nXKsfkGZqNmXRBygvcC2pemYhWwY/pqpQBw2
/OWZesyHiVVRhhjOlH5vhZOnfn2naVKYTpccHHVhclS1KATv9KkCBxekNYGL8XlT
DLn07I3wWdsrHY1GxYiaiDrGMNzy7JTslRChHQhaBGiQUoPqJfqHxmnSJxaAmhWw
/df3wuLMApFKrRoRNg1DMzbBF/+SZjHKiML/8ua7wjnO4J3eiC5P/xYY8vVlfeD6
d1kAFWmZ59vNu82b62LGxGVxIruvwFdvM48PIsyixVpJUNRYlM5JQ+EISmi4FDFg
aJ6ZRRLXbPO80K0IqVhLAXsFYnyzW7HJXjfkIpNvKDASWiT/ukxkMHOaYQtpConI
GzugjGvkkoiQsrw7LDfv
=ELKm
-----END PGP SIGNATURE-----

--kJMkLA1uPhjFFA+D--
