Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3KLIxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:53:41 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45296 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3KLIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:53:38 -0500
Message-ID: <5281EC8E.90501@monstr.eu>
Date: Tue, 12 Nov 2013 09:53:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1383151090-13885-1-git-send-email-soren.brinkmann@xilinx.com> <b3f788b3-dfc3-422e-9a74-b796c0fd3207@DB8EHSMHS004.ehs.local>
In-Reply-To: <b3f788b3-dfc3-422e-9a74-b796c0fd3207@DB8EHSMHS004.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Wg2jxv5IeJdvvv9oNDvD6uQOUbKhvrc7K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wg2jxv5IeJdvvv9oNDvD6uQOUbKhvrc7K
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On 11/06/2013 10:41 PM, S=C3=B6ren Brinkmann wrote:
> Hi Chris,
>=20
> any comments from your side? Could you consider applying it to your
> tree, please?

any update on this one?

What's the naming convention we should follow?

Is sdhci-of-arasan.c OK? Or should we use sdhci-arasan.c instead?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Wg2jxv5IeJdvvv9oNDvD6uQOUbKhvrc7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKB7I4ACgkQykllyylKDCFhlACdFtdiHiVNLWlgFY9VQX3M+svY
XgwAn3LgnDrPDxOgotNWQi0Ti1zgV3AD
=ioUD
-----END PGP SIGNATURE-----

--Wg2jxv5IeJdvvv9oNDvD6uQOUbKhvrc7K--
