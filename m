Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIXGpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:45:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbaIXGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:45:04 -0400
Date: Wed, 24 Sep 2014 08:41:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf@merrii.com, ctl@merrii.com
Subject: Re: [PATCH 0/6] ARM: sunxi: Add basic support for Allwinner A80 SoC
Message-ID: <20140924064124.GS15315@lukather>
References: <1411311493-24344-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bk6L21jbBNK7V1Rv"
Content-Disposition: inline
In-Reply-To: <1411311493-24344-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bk6L21jbBNK7V1Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chen-Yu,

On Sun, Sep 21, 2014 at 10:58:07PM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
>=20
> This patch series adds very basic support for Allwinner's A80 SoC,
> a big.LITTLE architecture with 4 Cortex-A7s and 4 Cortex-A15s.
>=20
> Development is done on the A80 Optimus Board, the defacto development
> board for the A80, with the accompanying SDK as a reference.=20
>=20
> So far I've been unable to get the board to boot from MMC, or
> using Android fastboot. I'm using Allwinner's FEL mode to load
> the bootloader and kernel+dtb image over USB. Notes on my attempts
> can be found here: http://linux-sunxi.org/User:Wens#A80_Optimus

It looks very nice, thanks a lot. You'll find a minor comments inline.

One thing I forgot to ask you about when doing the A23, and that would
nice to do is to update the documentation we have in
Documentation/arm/sunxi/README with the A23 and A80 infos you've been
able to gather.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Bk6L21jbBNK7V1Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUImeUAAoJEBx+YmzsjxAgC00QAKjq+vKkxpcYoWTWVdMu4nLb
uGQCqPTrBDrW+CtewlO8fXiRw53Dzrbtxrjc59WoAQ2iviG1uiBQIhLOfxyoKmg1
zs8h3E3dNvPdtvKmIXOj3jiq15hEqiTJXJqmWYy56TFsNTHPs0BHB/Bbecu5iILy
Oj9nKNh2f9nGrksaimKDidMRp63dldmo/McGPoRTPP/qijqtNClczfzSecxBX7Rb
xcVNSFaXfelySVeeVhceIGLiFtlV7mtn2sgqoZU9PHXOly4GNDqkDWC1+48OmTQL
Sb/K5yY0JWW/Pci5bukNrekwkqfTUOAAeLl8hlncRC1ISi/Joh+eNmmz3yvO+jC5
fYL3h4cJ8ayBUgAaU/SmG7Ikwa0PfnKRp7ndO7I3TwexJUDmYFxPXWnPIZ7GdRry
e7E+bCqvSYhGXFM+OkceieAUgCoz5Jky6rGoBrlCyRr1MsM9RezHr39nhh06UBoP
03e7D75BFBUPGWTsTvtmYv0Ulo3fIq9KASzOHKOYjJOY/tdDjJfD3PWX2N2P39uj
oSEIUV2iRbwLCBegxvT0KyaC+van+43+ZInMhXL46XXvOtBFlFTC5f/U25maDDs5
nNMo8trPK2Bh7sxX9bVeRrkWByaNhB0ORL8EPLylZ8QnPFDq8rkfnlbvQ9MYQWCZ
5guf86B8YKH116J31Oji
=0CLX
-----END PGP SIGNATURE-----

--Bk6L21jbBNK7V1Rv--
