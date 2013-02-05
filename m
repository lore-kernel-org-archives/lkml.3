Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3BEJeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:34:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51877 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3BEJeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:34:09 -0500
Date: Tue, 5 Feb 2013 11:33:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 25/30] ARM: OMAP3: omap3pandora: Adapt to ehci-omap
 changes
Message-ID: <20130205093358.GH32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-26-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xp2nimoPFnvF0aLh"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-26-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Xp2nimoPFnvF0aLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:26PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 2, so provide binding information for it.
>=20
> Model RESET for HS USB Port 2 as GPIO fixed regulator and link
> it to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Xp2nimoPFnvF0aLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENIGAAoJEIaOsuA1yqRER0gP/1qNFrM7W/N5F1fPyV32ZXFw
R3zhCRe1AqAZg39yVvdx3aBSgdjVSMFjBAcI+YRf+EvcwrF3H95R8lpL68S9hHpK
wRpKoqftS1cgId7slIwe9+UoK1urV/BMEMGHHktIXNV+7Cv81nLluFR5icuZykGk
nD3tRa82KrxyOqggyMUzV9r+EvD3xTNAPAGLFJJOcyK08Z0lgBvpleTxXTGb/9ic
d3mt7fwrvcX+VMwN9OwdAA/M6k/WL3govG7TNdybXC+32nU0BOS0VIApr9UL8TBQ
nP/o7XCGJR9XH3TZ8Q9zmy0PCO3aYTpQ11ZG2IL45RaIOuAFHusxWN7oVef68ppX
qrrjcWdF/eLfJ4pYfNjuY7ym88te+dW1g28JLRy8W4O7/oIyggy/1wdSiKmUfiuP
NmRCCoubKuPjHOnqmQmrQDnsa7r0vOdwXYcJlgFetcVCmJu6p94DcR5wANXBNXaC
97nzoN9P0rNtAXJp95C7ajoAoJ4C+d2ksOgG6s3auWvs+Usz8beF1/8NV0ZH/Kj+
FlMGxNuTEOSdozmooVSx+aBbD3g0qj0VHUP+XcgsdrzeVqCGjS94KAJa5hTxkqi1
EAtYYLqSWgiJRG0XD9CTRtVSjmn/2EYyJwioY8QIIxVPN6W4/01oMwxmmPwqqIju
KjSTxufoN9akHhRG2fY1
=gST8
-----END PGP SIGNATURE-----

--Xp2nimoPFnvF0aLh--
