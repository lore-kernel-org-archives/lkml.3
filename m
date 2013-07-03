Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3GCFxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:53:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55473 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3GCFxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:53:44 -0400
Message-ID: <51D3BC5C.1080505@monstr.eu>
Date: Wed, 03 Jul 2013 07:53:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Michal Simek <michal.simek@xilinx.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the xilinx tree
References: <20130703111030.c0df2a231fc3e4ba6cb566cd@canb.auug.org.au>
In-Reply-To: <20130703111030.c0df2a231fc3e4ba6cb566cd@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2AIOKXHDTCDSEGAAUMARK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2AIOKXHDTCDSEGAAUMARK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On 07/03/2013 03:10 AM, Stephen Rothwell wrote:
> Hi Michal,
>=20
> Today's linux-next merge of the xilinx tree got conflicts in several fi=
les.
>=20
> These conflicts are caused by a set of old patches in the xilinx tree
> other copies of which have been merged upstream a while ago.  I fact th=
e
> xilinx tree currently adds no changes to linux-next at all.   Could you=

> please clean up this tree?

I have fixed it - it should be fixed there soon.
But I am thinking about removing this tree from linux-next
because we are pushing arm changes through arm-soc tree
and they require to have specific feature branches.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2AIOKXHDTCDSEGAAUMARK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHTvFwACgkQykllyylKDCH4aACglkvNOPFlQKyG6YImvNdssRHa
dLAAn3/V250CZOIj1mIxTTDO5hB2zFgb
=k7C7
-----END PGP SIGNATURE-----

------enig2AIOKXHDTCDSEGAAUMARK--
