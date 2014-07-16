Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074AbaGPPJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:09:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55659 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaGPPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:09:50 -0400
Date: Wed, 16 Jul 2014 10:09:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <Peter.Chen@freescale.com>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/8] usb: rename phy to usb_phy in HCD
Message-ID: <20140716150932.GF1365@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-5-git-send-email-antoine.tenart@free-electrons.com>
 <53C54F07.4050808@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <53C54F07.4050808@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 07:55:51PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 07/15/2014 06:39 PM, Antoine T=E9nart wrote:
>=20
> >The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> >modifications are done in all drivers accessing it.
>=20
> >Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
>=20
>    I've been thru that and such change has been turned down already.

can you find a link to that thread by any chance ?

--=20
balbi

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxpWsAAoJEIaOsuA1yqRExoUQAKT5AagVkS0l/tLYNXYL7oik
e7a8u4Pa+VHpsYZGUGklCFCfoACdNGD29npeiPqDg6r1sFFNW9sphUB+qN9EHoXS
gCylTVpsZMJwdur1D/gJX0xVjIDtYzKATyVjMeJKT4ThTX2YD58l4XWzaJEmFruV
BRUc4YJ9V4gKMBZuD3TE+gGYotFAZQID+kVGCHbXp0BjymAnRXeCAWK+GO/uk3A3
Rr3tySD9fFMLxQTjfgs71l3/k9OGcDgs1KJCkL2zvghNCIuX5yiREArl3yQ8uYen
gcT3WV2TjobEj67nHykhhZr+XrJZ0qt6AhIlmH2LY9HF9/mejPbDXCeS4kbuKiYl
B0h8+ALSmP+9xR+pNIeUCP7fXGzPoHg1GfxGycIbYU5Xxl2rQaNQVqmf5EV3+zKq
ghbb6M4pOdOFKVmE//PkaxpkBtWHDDztrzA31YMLxbDfPBE+ff+1SDtzR1MkVcZ3
MDmjHfMozLtUF9Kj1Ud8KDE8gPhd4jYJDeLOEY8vNExGA4JUdHgdiTSvjHBpEEUJ
nbHfRcj3W7ssm6OqEkOQNEg2oWwgauX8Ucag4z13HqrbFpx/c032SCK8WXfR2vUK
cCekRiBU6TAbFVCL04SpFTjGyjKTfos/b7zlEX/NO5H/Xq5MnxCZs+Z6nMWTewre
OSU7KR/hDfiRqcLu4N2C
=ZN1D
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
