Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3FMNHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:07:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3FMNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:06:57 -0400
Message-ID: <51B9C3B6.1080707@ti.com>
Date: Thu, 13 Jun 2013 16:05:58 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com> <51A43E0A.8090201@ti.com>
In-Reply-To: <51A43E0A.8090201@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2OVELJTAMTAOLKXJQHTRA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OVELJTAMTAOLKXJQHTRA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 28/05/13 08:18, Kishon Vijay Abraham I wrote:
> Hi Tony,
>=20
> On Friday 17 May 2013 06:52 PM, Kishon Vijay Abraham I wrote:
>> In order for controllers to get PHY in case of non dt boot, the phy
>> binding information (phy label) should be added in the platform
>> data of the controller.
>=20
> This series would be needed to get MUSB working in OMAP3 boards for
> non-dt boot case. Do you think this is good enough to go in this rc cyc=
le?

Did this or some other solution go forward? I'm still unable to boot
with usb-gadget-ethernet with v3.10-rc5.

 Tomi



------enig2OVELJTAMTAOLKXJQHTRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRucO2AAoJEPo9qoy8lh71WVsP/jmjAagz6yP6Pcb/UJs6Zlf7
EFSDgv3zc7YOPheEGruvwbiXO4EzkIFBmkOLXzPj3VNf0DtKEmyw5juInDzI2pYT
slaeLMZsHTBgmfHvsHKJX3vlCMyhkEuD1QXeFUvebTKy/bzQpbQF7Hr+zdnZ3w4K
UHKrNNJwynEhm95NuFfUB0HDNcaKV0X8oi3uMW5ilAzbrHxugsyBwg+HD9Y2m02W
VeyCzM6c/xOGuevYMyCWIInxk2DvbXIiXG+OrD10LEPhwVVibfgWwHrpOwCysCJC
00r5zL0FQliGuOPA08SlLYr46U+y1JvsoWy5/uVGJwMEstPSdbAs6A7mmhBbFekq
BuMbA7SOvWSJxSk0XIUl+p5gzug1eX4yf+w1kkXO4J+nclM/sN4eDnPsCUKGLjlm
ZhI+/8pIfJoNg+zz1s/jvLqzMOnLovitlfnm9zfMOf1OqrpwA6stMTH5wyJ7rltP
mHcbxCWNDkHn2qU8BMaFV4gL+Op8V3bxVCfCxfB6JQf3HUhATIl4A5uPSnazA2PO
1F6vI8bIFJJeyg5SP56thDIPffs6KKAWXQd9N5QhydnFkS9HEeVBuQ+u6t7UWeL+
Fox19gOtPsBl5DWrLncvjNT0//ab7fxFFLpb//vogDRMfsUYZqtUjPo0xWXoJLeR
ZY0/MWIVK4tXJ/ry7Mpt
=NJQ9
-----END PGP SIGNATURE-----

------enig2OVELJTAMTAOLKXJQHTRA--
