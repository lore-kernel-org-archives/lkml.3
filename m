Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3AQLs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:48:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab3AQLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:48:56 -0500
Date: Thu, 17 Jan 2013 13:48:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 18/22] USB: ehci-omap: Don't free gpios that we didn't
 request
Message-ID: <20130117114838.GH18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-19-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-19-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 01:30:27PM +0200, Roger Quadros wrote:
> This driver does not request any gpios so don't free them.
> Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
> with ehci-omap in use.
>=20
> CC: Alan Stern <stern@rowland.harvard.edu>
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

should this go to stable ?

--=20
balbi

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+UWAAoJEIaOsuA1yqREJpAQAKxyGSbMsQK8eClTVtPhosmF
WL6j5rJeKZzsAgq71Iv2fVmjBtjMa/I20M41E0+FFpZt18B8D0aO27CaSBYUEigg
h1CgSmbs5ZFylHMxWMaRBtoj9QSCC7ch2Zh1NDrjLdUqF/kF9tXPflY8iOdC1vbI
TVWLJWcFYssFXWeegZ5tW+Qfkbj2wTt5dHEMjdGUgHy29T2BYcepOyuFuFKvh1j4
oZyClEdsIpqt5TG+EUJ9xoIXlfbws/dEnsSCrjyfeRcIjWe+UCj+uMNwlqBbHZZH
f1OMmzZGA1iq0k43A+/5G5bki7VO/K884oZKK82Fe3bgptUBtOH0j3m/Hve+lPuu
WoTWlG7Ix6jzAjgaI9LNJnp111xmIdlHS/zXCDuzAuE+Dq9Ui8Mx7+Rkz/RRjhfI
vAiqLFrCC35AF8i72q69uVOEoC11cN7PzqCo96TDXVoUGx96Xh/jq1ti489nj4CM
EFGzpag1lEwHnZcqRN+6MGJQjeIks5dEciqghvSTMWPFcjK05KXhqywVSqb7aYii
cQKJOipjrBiQIP2g7oFXH0JWKlmKxGIVjj6Fys3LgCeMRWAoLh1zClMBum2o9UL7
MXSYYUiDbJLncbjuHhQK3MZ1rLFNgRCyo9g8fSiq1U/v4CWOx8Iqrc+ehn4ySfUc
m+RG9JkKAz2nw7JDgyny
=hdAN
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
