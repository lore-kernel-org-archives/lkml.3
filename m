Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaE1HuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:50:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42801 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751441AbaE1HuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:50:05 -0400
Date: Wed, 28 May 2014 09:47:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140528074712.GM4730@lukather>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140514123419.GK29258@lukather>
 <20140514160520.GA4679@kroah.com>
 <20140515091438.GR29258@lukather>
 <20140527225318.GA21602@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HLsZ5Z1opAQvdr2J"
Content-Disposition: inline
In-Reply-To: <20140527225318.GA21602@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HLsZ5Z1opAQvdr2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 03:53:18PM -0700, Greg Kroah-Hartman wrote:
> On Thu, May 15, 2014 at 11:14:38AM +0200, Maxime Ripard wrote:
> > Hi Greg,
> >=20
> > On Wed, May 14, 2014 at 06:05:20PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, May 14, 2014 at 02:34:19PM +0200, Maxime Ripard wrote:
> > > > On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> > > > > Hi everyone,
> > > > >=20
> > > > > This patchset adds support for the USB controllers found in the
> > > > > Allwinner A31.
> > > > >=20
> > > > > While the design is similar to the earlier Allwinner SoCs that are
> > > > > already supported, a few details here and there change, like the =
fact
> > > > > that the PHYs now have one clock per phy, while it used to be onl=
y one
> > > > > for all the PHYs.
> > > > >=20
> > > > > Resent adding Alan Stern's Acked-by and puting Greg KH in the
> > > > > recipients this time...
> > > >=20
> > > > Applied patches 2, 7 and 8.
> > >=20
> > > Feel free to apply patches 5 and 6 to your tree, as your branch needs
> > > these, with my:
> > >=20
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >=20
> > > Or, if you want me to take them, just let me know and I will.
> >=20
> > You can merge them, I don't need them in any of my branch.
>=20
> Now applied, thanks.

Great, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HLsZ5Z1opAQvdr2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThZSAAAoJEBx+YmzsjxAgcKwP/j33vxpGCbCaNtDCAM6pAyfB
mFmzK9dNr0oJ4VNhFo7PpCG08betavYXnvrs7ow7mIMt4c4LCjnmap7/mgo8HAVa
9VJ8fxC2RyU6K77YcPgaJt/xSImxKFv4HvLou8L4ka3ugLZtRG2S6a9V+JtV4QfB
vaPsoheJ64HZD0A75/PJe3QZpnnOTSkx/DLMsVfb5WU11IjVxFup9AGXDKRsUAoY
ki7WUqTqcsvPbIgrC8rT/626mBzQmOJPFpk0H2OOS1ZzfY/WV2cj/68kSif2lotN
uzgqLP8+3nKiPIuxw1HxZlsk3vSqcrc9ALwflaT8ofepbgMl7Hi00H135MrOtV17
dgzg1+NX/HRvw5+vFc1UE8pr7Vk9FZFp1beaZvIZAv7M4zxca5BEdKCH6NbIKvs7
bxqr+KGP3m4ZL/GGg+N5tEX6D4hSbYBlY/UdKpAbg7ianPIFry6fUfORwuuCtMIm
UODm+dNdmMvvf8ValIwPO+EdWO6E9VCf+6kkcRtR/TaFUh3gxxStSS/A+FCI7N/I
CrY60/soWZIvxADb7CoufGyEh3AMfWBh6cZSJ5zNf52ala5HiDiVuOIpQCP6on2j
B6Sc2Q6ZG+BBx9VtLkG/UJTLQSB7k2HsCYJwqT7B6R1w2GRZHuHUc8/sRcliHNqc
hb7HbRoIORCnmpBuTXpz
=2eIf
-----END PGP SIGNATURE-----

--HLsZ5Z1opAQvdr2J--
