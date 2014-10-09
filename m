Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbaJICyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:54:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbaJICyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:54:41 -0400
Message-ID: <5435F8EB.2040407@suse.de>
Date: Thu, 09 Oct 2014 04:54:35 +0200
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/5] ARM: sunxi: Add basic support for Allwinner A80
 SoC
References: <1412773376-25212-1-git-send-email-wens@csie.org>
In-Reply-To: <1412773376-25212-1-git-send-email-wens@csie.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RMdukjvIo3OsAg5WOBniW7Kq2WbgXbNWE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RMdukjvIo3OsAg5WOBniW7Kq2WbgXbNWE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

Am 08.10.2014 um 15:02 schrieb Chen-Yu Tsai:
> This is v3 of the initial Allwinner A80 support series.
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

Tested-by: Andreas F=E4rber <afaerber@suse.de>

With this patch set on top of Maxime's sunxi-next branch, I get as far
as searching for the rootfs.

CPUs 1-7 fail to boot with -38, which I guess is due to the vendor
U-Boot not yet supporting PSCI.

Thanks a lot for your work and help, Chen-Yu!

Regards,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 16746 AG N=FCrnbe=
rg


--RMdukjvIo3OsAg5WOBniW7Kq2WbgXbNWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUNfjrAAoJEPou0S0+fgE/u2gP/j3RXl6WpJu458YhkH+rH6Gd
6CMV9D2M2clB8y0jbl+XkvQ2C2Y7V0AnrR7LZCCZODU5fd0NYLFoAY28UtdFNVh9
mtJguueR5dM6Ys5JSjHGZD326uxhu95s9j1dfCbbIS2MzUz+Z836YYQUIIGfR/Ck
2HWEyF2AF5RqVkv6wKn8k2DlMqsV39k1TzFhw/gjnshb9c/vyxWf1AflInYw2qkG
jnt/TXBRc0W4Z42GbY2Oy5asbzrABn7iSateGnd7g4L0+ar1OZx3yUT0lDLewhyJ
0PNwCqAIAdVYTZjGgRFM2+f8zLUCd66ytLV0E7ICXflr9gjUYdUS254jjO6Pw3NJ
0TmM9qkYHayNBSlWWthFAcQL5BXxCuoHty1xS7F89a5EHpT2gy2xQlLFLOgeCCsZ
swqMHZOhpU7F/d0fYK/Be4V6Sd+lmrsYJ2Qcovc0kfk9qKDwUr2vfrHtJ5mctudj
6MMCi58U0UXpeOaFIfu6azd6qHQluY23NJ+mphQdz8+WLlCwut25WP0p4kEsZgC2
c08nwXjTgYYyt/IzQ7wR970HFjnTahYlOjYd5BcxgkF955pHQju/GELtgmIm1i/U
wqpsPkP90psEIpzh2+/MFsUcxt2z+4JakaMFNFi9BnCEQZ4qO9IXMBvxnfJ2aDzv
/5wfaUZc+KGgS1QN1Ace
=LOA8
-----END PGP SIGNATURE-----

--RMdukjvIo3OsAg5WOBniW7Kq2WbgXbNWE--
