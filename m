Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3BNJY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:24:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57935 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab3BNJYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:24:54 -0500
Message-ID: <511CAD5D.2050502@ti.com>
Date: Thu, 14 Feb 2013 11:24:45 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <andi@etezian.org>, <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com> <511B4C60.50404@ti.com> <CAB=otbSX_O-zbHZuPWPSEU0D1s3uKfZfeatoguoRiwogS5tVHQ@mail.gmail.com>
In-Reply-To: <CAB=otbSX_O-zbHZuPWPSEU0D1s3uKfZfeatoguoRiwogS5tVHQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1C80B7BA41BCEDB035534D44"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig1C80B7BA41BCEDB035534D44
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-14 02:07, Ruslan Bilovol wrote:

> This patch is exactly a part of mainlining of the BlazeTablet board sup=
port :)
> The goal is to have as much as possible support of this board in the
> 'vanilla' kernel.
> The BlazeTablet mainlining is already ongoing (
> https://patchwork.kernel.org/patch/2118281/ )
> and I hope we will have some support of this board in near future.
> The BlazeTablet's LCD panel support is very important thing for us to
> have it in mainline because
> without it the BlazeTablet becomes a 'black brick' and it is painful
> for us to port this
> driver against each new version of kernel.

Ok, good to hear you're pushing it to mainline. However, you should
mentally prepare for it being a black brick =3D(.

Tony said he's not adding new board files, only DT from now on. The
display subsystem driver and the panel drivers do not work with DT yet,
and it will still take some time for that to realize.

Thus adding this driver would help nothing, as it couldn't be used. And
after the DSS and the panel drivers are made to work with DT (which is a
big job, needing large rewrites of the drivers), there's a rework that
has to be done with this driver to make it compatible with the new DSS
model.

So, I'm still inclined to say that we shouldn't merge this.

 Tomi



--------------enig1C80B7BA41BCEDB035534D44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRHK1dAAoJEPo9qoy8lh71iz8P/3Nw6J0iDl/Shfynnwr6kG0i
F/x7PbGAvQ4IkvU5+gHle+vd9Wzsmmjv51MfTHu9uWKRtB2gCEsTS40PkPqa5Kn0
2y5+sTXPmzVmvRLMRVBsaDaIolC48lz9IWsd4bUeP0KIcTjUi5BfkfmJhNiTT20h
mnr3cWQSznf0wucY3HDcv7TI2QcpZmsQvQ1jKMuilhBgA62INbt2e9fkRIk1xNXJ
UBfmbbYV12Svv8eprV/TnVZ0QwDY67DN31ZutGRwCo7N4DXs3ZHoi0+EOltfl0Ut
4psmCSUrIaZQmQPoaVrUcdwwxYbdZZVNiV0CQHYPvoNEWbwfGu9JmcBgZtcxaUsR
IxzWkrEj/JUw+NC2Z/gw9Cs18eoS76qSvqDdIqk7Ru0wmO2AxYg6iz6DXIEPJPhH
I04IlNBURgT5/zWZKc51WOX4n83mGaeyJPIJ7tio3TEmFQ04zDfpD+d+dQViCBZ4
eVdnsneGPgW9KQfMOtuRb+ViSHgaNI1+BKFO40AaqTx5W9L3pHs2sD3F0/ajjJld
SFMwh/4GqWGs6y5DDQINY7p/OG6yfssMC8e8Z6WSiZblBeJk1R3n6p+7VIvtW6qf
T7lUiSw+u75Vhf8A85+qbZPHBN3G0e/QHuHSYfEErP/PkRvQNt82A3YuhNecWZ67
YeDkQXh+sYbGYrKIykFx
=eTse
-----END PGP SIGNATURE-----

--------------enig1C80B7BA41BCEDB035534D44--
