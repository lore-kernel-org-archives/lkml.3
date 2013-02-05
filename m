Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3BEJ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:28:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41594 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:28:19 -0500
Date: Tue, 5 Feb 2013 11:28:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 13/30] ARM: OMAP2+: omap4panda: Provide USB Host's PHY
 platform data
Message-ID: <20130205092807.GV32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-14-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="22hJjvOmZW2O/jbw"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-14-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--22hJjvOmZW2O/jbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:14PM +0200, Roger Quadros wrote:
> Add platform device and data for 'nop-usb-xceiv'. This will be used
> as PHY for HS USB port 1, so provide binding information for it.
>=20
> Get rid of managing the PHY clock as it will be done by the PHY driver.
> For that to work we create a clock alias that links the PHY clock name
> to the PHY device name.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--22hJjvOmZW2O/jbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENCnAAoJEIaOsuA1yqRET/wP/iWWXf4QQju1PbJJmbxlbEeH
IPWrvZlBY5B77Ezu2BX7z7IkCW7nLUQriikfqPM0xSR6aJ3402SK/9uZVwAS5Hny
qmKL5TqsCRYCM7cEUaBBYdjSnn3kOBYKXn1Ik5bZWLAzZDrq+RiCoomaV0bVj6Gu
zGsRbCP9KJt71g1q3poXAwj6Y+7RUihMZKqhzZKpQXaB4S1LV/zgQFC3oVBeOv6B
LfTIb4iJFsVYnPzPuSwbCw3v2BF7seLFLK0mZuU4paPfFxm1rcUWI0WyZpv955vD
UVt8Vtnozu2CAGBQtOs7iEOf++ZxqJ1Uu/kh37DOnvw0BpK0EpQv7Mmg0+f18xN7
rlx/dvYyxFLDqKUpltC3YdBzG8fnjQthkr9IaSZGb5Se8syXbjMkfThR5b8zZPOL
EU1nV8C1eh541mNsTAIoSd6zSF3DhrJFOU5UuUs1ICYmKDKgudRMKPXe7MTKIn+z
0v8/X2QcfN1gkJVBKrrmDWakayx0iXNBEW7q3vesSZR0rKzGO2th2Mhxd0OWXkRl
/KRMm7u2cCoaKnk2qu1CXPe/wWQajL/Ro06ZPCSe0mvPyDvUAVS+rpvtTTJLd2co
6EKH4y2jOPHglKZXvLgS3Mgk/6AjRFsF/T6jMIrBFWpn2gHRhU+cir7hrY6V5EYQ
s0x/8lbWeMLO99b6rJVH
=LREE
-----END PGP SIGNATURE-----

--22hJjvOmZW2O/jbw--
