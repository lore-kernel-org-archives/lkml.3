Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3HAFtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:49:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51694 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3HAFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:49:50 -0400
Message-ID: <51F9F6DF.5070306@ti.com>
Date: Thu, 1 Aug 2013 08:49:19 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        =?UTF-8?B?UGFsaSA=?= =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [26/84] ARM: OMAP: RX-51: change probe order of touchscreen and
 panel SPI devices
References: <lsq.1375276989.521602504@decadent.org.uk>
In-Reply-To: <lsq.1375276989.521602504@decadent.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="gHt6uuDvHioS6fAJu3F5Mhtjcn1MRxQk0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gHt6uuDvHioS6fAJu3F5Mhtjcn1MRxQk0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 31/07/13 16:23, Ben Hutchings wrote:
> 3.2.50-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> ------------------
>=20
> From: Aaro Koskinen <aaro.koskinen@iki.fi>
>=20
> commit e65f131a14726e5f1b880a528271a52428e5b3a5 upstream.
>=20
> Commit 9fdca9df (spi: omap2-mcspi: convert to module_platform_driver)
> broke the SPI display/panel driver probe on RX-51/N900. The exact cause=
 is
> not fully understood, but it seems to be related to the probe order. SP=
I
> communication to the panel driver (spi1.2) fails unless the touchscreen=

> (spi1.0) has been probed/initialized before. When the omap2-mcspi drive=
r
> was converted to a platform driver, it resulted in that the devices are=

> probed immediately after the board registers them in the order they are=

> listed in the board file.

I'm not really familiar with this issue, but:

The commit 9fdca9df was merged to v3.5. Has that also been backported to
3.2? If not, I don't think this patch is needed for 3.2, as the patch
causing the problem is not in 3.2.

 Tomi



--gHt6uuDvHioS6fAJu3F5Mhtjcn1MRxQk0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR+fbfAAoJEPo9qoy8lh716foQAK6EuU4G5Y3IXpsA/Zt5sPp4
CK0GIoRcXIAz9tYqSbPG1+leIXDgsy9G7l9FSSWCcbfdo9pHCwlhUqsOs9enM7vo
qiD5NjIln1+aoXnsdkjj/YwrArE/fec8DrnLzqjEubKDwWyeMDaBReEpS+nX5hof
Kar5fYB30hNComcI8ReEzYS7ES5LkXir4Vn8HHDTuTign3ezMQTesLWHzefsRyXq
EeIuDlX1qzVLQIKAwMoVmNQnycQ/H5P7Cv4DVfihaaQsn7Bmbtb+B4tGpT6U44Q4
uBpz0O4PjL3vNIZUYzlV7fFqpTpAjJgaOC0RCsiA8o9AJmio/0oNxGiH8sf7yi9g
8amCnwRVGi8dnYuZfwwvCoS3yZn0KISwn+gFLy2VFjeweGWZ9ErGOYcp4IKBOgRW
K36gVZqJ3H/eAfZfhLYlOm5h1pbdisAFl57HmawIWSvSCVMPreK9ToYwtC87/jz+
/7gC6bcx/KxQsAqYTiH7oXPUT45jH0O+iaz+/qHRsFxkxMgVJmpC+e6sKW1bNuk6
ASWPPLczsZIQDck6dmjKbNHRdlo20bPIqbJSBNlwSQFcUnC7h+tmtuhuue15Dt45
XdlHOlSjtAYEmrESc3NZuk7r1d8OCkZNC/iEumQCKPQ8bcstTj1o2gCEb3boOkXM
We9B+iqFvYGXIf4pugux
=pJkk
-----END PGP SIGNATURE-----

--gHt6uuDvHioS6fAJu3F5Mhtjcn1MRxQk0--
