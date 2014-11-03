Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKCMfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:35:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbaKCMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:35:04 -0500
Date: Mon, 3 Nov 2014 13:33:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH v4 02/58] serial: at91: Use dmaengine_slave_config API
Message-ID: <20141103123311.GJ11263@lukather>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
 <1414531573-18807-3-git-send-email-maxime.ripard@free-electrons.com>
 <5457632C.5020002@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AwgMNpd3VkAVXjS"
Content-Disposition: inline
In-Reply-To: <5457632C.5020002@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AwgMNpd3VkAVXjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Mon, Nov 03, 2014 at 12:12:44PM +0100, Nicolas Ferre wrote:
> On 28/10/2014 22:25, Maxime Ripard :
> > We are removing the dmaengine_device_control API, that shouldn't even h=
ave been
> > exposed in the first place. Change the callers to use the proper API.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Thanks, Maxime. Do I have to carry the patch myself or is it part of a
> series?

I think it would be better to keep it together with that serie, since
we're removing dmaengine_device_control in a latter patch. If it's ok
for you of course.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7AwgMNpd3VkAVXjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV3YHAAoJEBx+YmzsjxAgPzoP+wWaY3A6vf9myfNhZOXB4a98
c1PIyMkiINbOMN0FAIzCHTh21tHkBNlw8sunYMtQDMi1J+fqpSbCfpHuP3J0VrsO
4KVm9cSMmaiOR3xm7n+s2xLGJJ2cq+L622vTGPr+fson/ZykVqjIHmxEhnmwJ4WK
EKGJDhiY9tHP3Mc9XFk8hD3Kp9CzZ84Cfw1JhabSIMZZmbVGyGbX9/P4B6bKl4dN
kkMacYg7L2XrOy+8+tC8/BhRqYtaW9DpX4gr2gFlg7TlxhGTe02SXZn8NKG2fWMw
zNmiGNxFRY+0LZT1t6Lb1CpoWO6x2vm3dVEnh9fFfiEBuQ5ebkDFpw+bl4/P98DD
0N6Mk9ZkdmCQIu+LNlVaU8jAxuraDY9dBomeN9g51tiev/cRk86E7CGqcvFgjsrF
pZvkxzUGboGeyZIXXHNfJEmIx64d7mJfUjj42rzTvDnbl6kGwKlHTFtEGQ/UCaY5
315Pa265j8Cfh7B2+L5pfruHA0bVhqjGFA3uaRchkwr1M8ALSJhr6ud3GckY/BF/
GMiss9vVX5dsCrvotzMA+BImM6QYreI0YdeGEzkp81ZkeoY2gwf8R29aKZzBphqY
jchr42/fYPRKyLz+Df6tOEbw1fq/SxIkIm1x6etipUNnNDODJlKLtfJppXPIepzl
kSV7uSPGLdjknZ6o4k3K
=SZ53
-----END PGP SIGNATURE-----

--7AwgMNpd3VkAVXjS--
