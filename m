Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaDGGCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 02:02:31 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54857 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDGGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 02:02:27 -0400
Message-ID: <53423F6F.5010504@monstr.eu>
Date: Mon, 07 Apr 2014 08:02:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com> <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com> <533BF905.6070701@samsung.com> <533BFF69.1060701@monstr.eu> <533D24D6.2030103@samsung.com> <533FE1BC.7050300@samsung.com>
In-Reply-To: <533FE1BC.7050300@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gSAAimj8V1TXmNtGpKOHiBX1WX7LpFTmI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gSAAimj8V1TXmNtGpKOHiBX1WX7LpFTmI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2014 12:58 PM, Pankaj Dubey wrote:
> On 04/03/2014 06:07 PM, Sylwester Nawrocki wrote:
>> On 02/04/14 14:15, Michal Simek wrote:
>>>> There were some patches posted for syscon to make it available in ea=
rlier
>>>> system initialization stage: https://lkml.org/lkml/2014/2/19/218
>>> I haven't finished this yet. I have to look at it again.
>> Thanks for the information, I assume this would be also useful
>> on the Exynos SoC series, so I'd be happy to see continuation
>> of those works.
>=20
> It is useful for Exynos SoC series and I have modified this patch serie=
s to use early syscon
> initialization API and I can see it's working.
> I have some observation for early initialization of syscon API which I =
will
> update in corresponding message thread.

Great. Please update that thread we should finish this implementation
to be useful for everybody.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--gSAAimj8V1TXmNtGpKOHiBX1WX7LpFTmI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCP28ACgkQykllyylKDCEAygCfQXdUMqZAYvviJyhWQsglE87a
8xQAn0dkthqUz7uIx9Hm99SxWewBojNb
=mtGD
-----END PGP SIGNATURE-----

--gSAAimj8V1TXmNtGpKOHiBX1WX7LpFTmI--
