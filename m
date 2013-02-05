Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3BEJew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:34:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37566 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3BEJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:34:47 -0500
Date: Tue, 5 Feb 2013 11:34:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 27/30] ARM: OMAP3: omap3touchbook: Adapt to ehci-omap
 changes
Message-ID: <20130205093435.GJ32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-28-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bsy/rPjPw3Zgz4JZ"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-28-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bsy/rPjPw3Zgz4JZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:28PM +0200, Roger Quadros wrote:
> Add 2 platform devices for 'nop-usb-xceiv'. These will be used as a
> PHY for HS USB Ports 1 and 2, so provide binding information for them.
>=20
> Model RESET for HS USB Port 2 as GPIO fixed regulator and link it
> to the respective 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Bsy/rPjPw3Zgz4JZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENIrAAoJEIaOsuA1yqRE72kP+wZcV/KLbzS1JgKxKmQm4azA
JbPJx0nZ4zvZ7SDLWSvEgQT2nRkeqIWBufBiS9/JKGtNP4LeEZeZdoNgxIl5XJRW
aVCA7MTR9KMrPVDVFljvTM65if1An4H1BX0Iy6JXANzK6i6cMCD3JeCckTlg7cHj
Qpv1cQS5Kdqyy7n2efBHHigjZEJr8EXO8Cs+dh6AAQBQaf4elaMysxxzXqoBwsJh
JpBOsTI+h0wEafRsJrTFyjjlYEBYy+4GdFro1LzWRxgsI5QmAWipoqZoa9lTOf49
yBcKZhNs1i1ZUK+nJRz2Y2fsS7KeM4X5Es74EOckIE9ARxu3Lt4oOT4SnI34bECa
GRj+dIjeGhkVe/avkdSy9VoFTaYnFnK6A9bwRB6i9zrc91QqUwX9J+zo4IdIRXrX
9uZyK+gb9Szi08dAnzU1u7G9MS0wzru4Ai5lsNmAI0eYm4SovbAo4i1kfxxc+tSV
mOsHELtP9EphTIWuprIVWLzl7sLWjRWjuV+/RgDe/9IRtZrxWSBfxvctg323Y18k
2gfln3Xbm7O4DS1MeyEWCSWr25hGjXYZafS5VUqKbIPsiZHlRytLHcpYzQjnOLo+
+HhcWRMxwB/vEbfmia0cbr0hCR6lFNFM1kmCS1o8lbEmq7mZ4Lgdv6fK7ygeoz/0
x/Re9SilSN51gQSLbsUw
=HGLC
-----END PGP SIGNATURE-----

--Bsy/rPjPw3Zgz4JZ--
