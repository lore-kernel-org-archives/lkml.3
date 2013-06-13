Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3FMBej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:34:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34783 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab3FMBei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:34:38 -0400
Date: Thu, 13 Jun 2013 04:33:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] USB: PHY: Improve PHY selection logic
Message-ID: <20130613013317.GA12078@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369999743-11758-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1369999743-11758-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 02:29:01PM +0300, Roger Quadros wrote:
> Hi,
>=20
> Improve Kconfig so that the relevant PHY driver can be explicitely
> selected by the controller driver instead of relying on the user
> to do so.
>=20
> Detailed description in patch 1.
>=20
> v2:
> - Merge patches 3-5 into the first patch to prevent circular dependency
> between the Kconfig options during bisection.

FYI, these patches were dropped because they cause linking issues as
noted by Greg.

--=20
balbi

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuSFdAAoJEIaOsuA1yqREeUcP/RTWwOg3nsEv0pLqW4vyt4qi
+VYAWhf6Yb+SUePCuIJLhdpuI61KgsKwJ4F84uxWs4gChrgdHqigViMQeEAhTNsI
QwbYBjQj2S/StszTYG1zRdseeBSL99Tvasqic9n7FP9MHg4QCkY8TR8VTzBKiHZ1
x1y0yowEC5imcGtZjmyzI41hR29JU5dVAc7edImIztcNSoywmQTRGcSC/2Ga8dq2
5yTuq0utqWv0Meumc0y2qVBbH1zZ/5bUFGfR91t4VxajEXYelC0sfuXpmDrX+hXD
D9CLm68lOsuZFcTOzhqrfUjcsFFc8IoGrUyfxTDu4X7Kal4nOsp3C0B0utM/t2rp
ybzXDsIif+hCY5h/K6g4Gb1rLSD8rakaEYNNezQCM/8qcTwMD8QJPr67wDKteYl1
ghMwd4TNYKNfrv625JUIltzSJWmgCcZMBS7tRRB4gZVCGAkRkn+VxIB6nZa6+sOt
vvEToa1EFIFjNJX3YFYhbmcMwj6SLDoNmfv1bJNV5K9ZxBf0O83CYIb6iV3W2V60
bhdEouBPRIKxsjlw47Fj8erOo18S9b3mV40QSHWi3jpzfHbr3VtsVw5AxvciGwzI
K3P/2MQmA39RUQ8V5vyZYqUITY83Xz+k61od61X8910FdYrCkIopIn0Y7E5NmFtN
gDECdu2Tib29nyUpNu8h
=aHBA
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
