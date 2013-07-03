Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3GCM6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:58:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56315 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3GCM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:58:11 -0400
Date: Wed, 3 Jul 2013 15:57:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
Message-ID: <20130703125719.GD15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51D28DB9.704@ti.com>
 <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 01:17:58PM -0400, Alan Stern wrote:
> A PCI-based EHCI controller has two power sources: the core well (which
> is turned off during suspend) and the auxiliary well (which remains
> powered).  That's how remote wakeup works; it uses the auxiliary well.

This, kinda, matches what OMAP tries to do with pad wakeup. Just that
pad wakeup sits outside of the device itself. Perhaps we could look into
how PCI handles the aux well and take some inspiration from there.

Any pointers under drivers/pci/ would be great :-)

--=20
balbi

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1B+vAAoJEIaOsuA1yqREti0P+wXM7xlwOz8N871VTg4ptbXw
lr0bVuOguXvZ+donKXZzqGG9Qf9JbwBIP/JPVGOrXUZeKXuk2vMUO7QMcGexFPRZ
iVfPggyxxxgkZWQo4tQIfBzm3MhgegvVzvx2z7DKqmroDwJoXJkZyOxuYBAa7pgI
DC6nXxtzMTv96TYt4l8Q8kpo5cvwXZzJl8ifZ3lw53AqZA1B0GVlQdT9bIs22Jsl
w+Zqq2sKmssPdo1uokm8Ay4iNttD4XRweZ4LPq4UvPtIviK/+WMkceqHIU7l2sfh
nTrPJqXMXr/F5A8e4CkfjWhX7l0rm+UIqVx2g9UPcyRBdqAtsdmJHbPurtGfEZ1p
3pMUYD8DvW+aK+WqbkL+oTht/xilTjNY74VcBXH67odRXiF0vkbHhAoTu3UJO8dW
OBmMSXG85aD4lsyFow4GDekJ5ZcMGQDLrvQmke5tdGDAfs8mWOMCdLtOnZ9JJd7I
2ASUYWgUMzoIKcnRAbAn2cCkNM5JY+vOpl+MzXzzXKw46cLj60n9Vlc3/xES7P+F
tdE23TEy6DOeebEAzaM6V8RwBluyVx8TjElDwNVvquISJuHWY3fEN0Qhe3yV5vD3
O7q49Hh+Z+CW1g4Dl/ZxC/zdaVrzYiizNYksvT2bL4pGPAAGdSzEflcSWzg3TUsP
uO+QqI/g4WyAqq3rZvep
=51TX
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
