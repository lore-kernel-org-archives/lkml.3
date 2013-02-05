Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3BEJcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3BEJcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:10 -0500
Date: Tue, 5 Feb 2013 11:31:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 16/30] ARM: OMAP3: 3430SDP: Adapt to ehci-omap changes
Message-ID: <20130205093135.GY32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-17-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sKosZo66cxuwvnFI"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-17-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sKosZo66cxuwvnFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:17PM +0200, Roger Quadros wrote:
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

--sKosZo66cxuwvnFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENF3AAoJEIaOsuA1yqRE/FAP+gLcYtx01Fm0sYC74fk4UUs4
GgGhsUJVXPN+ymkujZojhEptHtG3uMP0BPkjaK9M8qdMKoLshzQvsbKVfX0Olbyy
cWCgz35+OijyVXtGBjoJTv28nHDG9qBIR8xlT8WkYV4SHjSzYOVLxkfKVLxZvN5H
5EQsj0R1CvyHwCc2Bu3s+/yMaN3aY/Wnn6qFD+I84wSWuHayzBcDotWVFEzSZvku
S6s5sRsPIk2cM1jMJwofcYv3W6vCrV7qtrwnzkKXkFA7UMeFQQm2QY7aW0OgcLRT
kxR94QL9xdTbfsU+sHbcetGtwtVedD55vg2gins+RaA9F+qiBQ/T4d2EGi+47ire
Gk6nOhgWhHhR0daY2Esxt06qDzD74gdheApvn77Y2lmh+u/cY6xlorH7blt0bcBj
qRG4fkSuDR4IoZMdQeNyg30Mz1o65Qj2XgCe1Rcsvr0wqveiCyqeu6k3ilnXmlPr
n87/S/5cyIoPzHSoqjoP5MQz16ANA/ILTIXl07gprMs1v1ZoRf7ul76B/CGcFdnV
+7KWKieCG35XMMMs1fGipE3YNfVCIj50D7VxjCeckR9MY/qzkhh49yJ1qBIugLAj
fVecFo4K/GY3pgdtTnLLmJlJIPL2u05P3EeGjO14slB5IsHhGN8akoiJom1+m68z
/dhHaLpDrSPUGQJrcPF2
=ez69
-----END PGP SIGNATURE-----

--sKosZo66cxuwvnFI--
