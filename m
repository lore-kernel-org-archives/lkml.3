Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJKJUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 05:20:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbaJKJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 05:20:08 -0400
Date: Fri, 10 Oct 2014 20:26:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v3 0/5] ARM: sunxi: Add basic support for Allwinner A80
 SoC
Message-ID: <20141010182623.GP19438@lukather>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GTGEtWEe6jD60dxL"
Content-Disposition: inline
In-Reply-To: <1412773376-25212-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GTGEtWEe6jD60dxL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 09:02:51PM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
>=20
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
>=20
>=20
> Patch 1 introduces the compatible string for the A80.
>=20
> Patch 2 adds a barebone dtsi with just the cpu, memory and uart nodes.
>=20
> Patch 3 adds a barebone dts for the A80 Optimus Board.
>=20
> Patch 4 documents all the Allwinner SoCs we currently support.
>=20
> Patch 5 updates the sunxi README with a link to the A80's datasheet.

Applied all of them, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GTGEtWEe6jD60dxL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCTPAAoJEBx+YmzsjxAg2YwP/18Q0y5XUzu5Z02TtPkw1YV8
aFXrgGZAPcQQBf5tZ0exsg1MFWSXvZABzH8JeGunR1ns0LJLhBWju85VLWLrBHJv
uNz5R0ux5Bq7acLZHL5MDjhhX98+PZKdZPz/PJsEAkTzLkICTuVuX0wL1bUJicws
TSXM84lnK3/S+NfRRo7buEzyeA/cgTionNvvQMo97A3DPZoOtd/yat15nSXt0297
6TLVwySbiCdzp5K3T59BG+n4Bs1BBhg7BUCVJPAmdwEOQvA54v1t6MIRMbeY7FMK
oWk/Qmp1b56UC+v/5x+LG6ji+DjI3tUoVuooURd9+9BJ0U3z6kBevGPQ3KMsxuK3
C23nbwkfUm2QDcvQBSu9V++BS/edZ3jbm24tW9dt+uiYZnQKbXbV70zyPzpl3bik
I4+hyFLI0w7WJc26WiVBV3QcgOfO3+KFb18Uf22yG0Z7BpPhqrhbZ7AiLmPmQeyY
e1ItE8FoWeRnb/uv0SKHyvadLtRW1gmFYDPtNBab+j0LZ+C0puqU4nzgcl8zIW6d
XWPi5uhc9c5Rku9M3Ya8yJm+YnQFNonW/mCJ5MEdKlNE3WBRcz73PQtGkKp0MxDP
wFX75DK5eOQSsHKqRJ9Iuezri5AWC2ApgKdwmvnhM3uO+hFRZWyUL8BgFlvZC9XU
1PnDLtUPU904XTKubUsi
=f5Op
-----END PGP SIGNATURE-----

--GTGEtWEe6jD60dxL--
