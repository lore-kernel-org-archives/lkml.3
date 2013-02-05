Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3BEJdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:33:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51803 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab3BEJdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:33:37 -0500
Date: Tue, 5 Feb 2013 11:33:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 23/30] ARM: OMAP3: igep0020: Adapt to ehci-omap changes
Message-ID: <20130205093326.GF32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-24-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBYeLQbK9sqbzZRV"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-24-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UBYeLQbK9sqbzZRV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:24PM +0200, Roger Quadros wrote:
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

--UBYeLQbK9sqbzZRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENHmAAoJEIaOsuA1yqRErSQQAJa81K452A8QzPg/1S9mY18m
Z7Lr5ujUSbRFAa2JjmIPpN0nxFonO5tlqWoBKdEjW6Mb8mthDr0Zpz791d6VdVIi
khSK0IUbwN9pYsa7IhotIJPAOjRMuGMhwLyIPo+GWRgbTOUrE+Tpzo+sLmXF3KlB
wPVpm+GZ6wQh9SQmPlDOhl0loJzONZyQh1fEJkHuTsh5EAjQjh5JarfSGkR60cJw
MHHYD+xQfnu6RlmQHj+9u60RPZDVGjJB8TMyTBOmUEzIFX3MVXB4E6wr133cN/Ki
I9xs2cJ2fV1ysxmJM8FzN5XvofvUcPn7diXLXGOD/J3QOvbyzOIvLI5C4rwA7Spt
pgaD6OH8BB4au91qoI1QxkGJoZ3/zuGYTLb/+JrXSQEgcUIT2FXLQVLHzLSoP9mK
Mu+Lo+Hc9sXdCcLGGbJpbM8MMhnhthPSNhuekNTETlhiRMwwG1FeM98wXth18PZj
Oa25dMON4RtUDQ/mBJ4IpWdGsOhscAqLlHMV6msvq8HFJ55qJekLnOYVSBUFxIuz
K64wCuttNf1OwQCxvo7IiSkbzBKb3yyvv+4cv7R1d5j1dljZVKjvoNC/xA6QouHC
t+1rQBffmjZ/hdzyIyTAMLT4I6sCxbhvPbL6OkGaZVd/tJmjzR/H8yPSNo8DuyuH
7f4lWTJY7HMAYcHzM13r
=mYMC
-----END PGP SIGNATURE-----

--UBYeLQbK9sqbzZRV--
