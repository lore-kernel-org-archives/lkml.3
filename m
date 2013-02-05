Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3BEJc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51651 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3BEJc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:26 -0500
Date: Tue, 5 Feb 2013 11:32:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 19/30] ARM: OMAP: AM3517evm: Adapt to ehci-omap changes
Message-ID: <20130205093215.GB32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-20-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="03sphU6jKm9HdgU1"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-20-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--03sphU6jKm9HdgU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:20PM +0200, Roger Quadros wrote:
> Add 2 platform devices for 'nop-usb-xceiv'. These will be used as a
> PHY for HS USB Port 1 and 2, so provide binding information for them.
>=20
> Model RESET for HS USB Port 1 as GPIO fixed regulator and link it
> to the 'nop-usb-xceiv' PHY on port 1.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--03sphU6jKm9HdgU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENGfAAoJEIaOsuA1yqRERCYP/RpHlWpgm3lUhijerl2pnoc3
EhK7ZdLUHxOCysOCJCMr5k9aJB252U0hXo5pclA3CFh5YGFt8yNjDvr/JeEUqJAf
x/KqaiIh/CSTQfhy4qe5mFPxkNskREiaB9ziUR7nigFvcmFtO5HHAdB5LDtbriuV
PXfsM7D4VaUnwcY06sR/fFYytdvgh3xNAAoMnrA3kLG1Pe5aK/09F1116Ib5d9uk
G5VRzszfobGzAutMSiRAf0tekUptoIdTnPztavnrLs0GyCTAzMbXV7XUaZ2ER2DM
2w77u6yHMl1yPjqOwvlIW/DT/FSzSrMpiHHqN1y6e9NvuELgfLhUBT3T9NHAVhA7
EAFtpFSRBhkdl5ud26DEbzP7UsakRJGbDthNTygbBs8FrPNwYlpSmlqa45WujEJW
ybtTEK5KYWET8ZYa9oyqqGRi1+RGPiRdI0MKgl4m8hbbkZP6oHpyvbRtoHsSPheZ
M7XK/pgF19D9ApyhD2SmzPTC/kG5QJe/jz4q8VCv1EU14UlI5Ao2VRGUWKl/gsKD
a6AnRP/P5ZKiSCHrAI3t8LyCEHx8F8c7jNOoq6dtWLmvvxOKA8aOe3/A+6HC9nup
4RWgZhPqYHp8zZ8aemgHEMSbtYRZ+D7ezNgx3YHcwScxmbvjQfdCGSGHcV2eYbWX
luXBP4b+W4PNVw3UjBZC
=Y4YV
-----END PGP SIGNATURE-----

--03sphU6jKm9HdgU1--
