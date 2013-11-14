Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3KNJkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:40:15 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42737 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KNJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:40:11 -0500
Message-ID: <52849A65.9030500@monstr.eu>
Date: Thu, 14 Nov 2013 10:39:49 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 00/11] Consolidate asm/fixmap.h files
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>  <52824BBC.9020401@monstr.eu> <1384271711.24631.5.camel@deneb.redhat.com>
In-Reply-To: <1384271711.24631.5.camel@deneb.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iQtiGn9GE0PIJmOHe35N72OtEjLmxDLif"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iQtiGn9GE0PIJmOHe35N72OtEjLmxDLif
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/12/2013 04:55 PM, Mark Salter wrote:
> On Tue, 2013-11-12 at 16:39 +0100, Michal Simek wrote:
>> On 11/12/2013 02:22 PM, Mark Salter wrote:
>>>
>>>  arch/arm/include/asm/fixmap.h        |  25 ++------
>>>  arch/hexagon/include/asm/fixmap.h    |  40 +------------
>>>  arch/metag/include/asm/fixmap.h      |  32 +----------
>>>  arch/microblaze/include/asm/fixmap.h |  44 +-------------
>>>  arch/mips/include/asm/fixmap.h       |  33 +----------
>>>  arch/powerpc/include/asm/fixmap.h    |  44 +-------------
>>>  arch/sh/include/asm/fixmap.h         |  39 +------------
>>>  arch/tile/include/asm/fixmap.h       |  33 +----------
>>>  arch/um/include/asm/fixmap.h         |  40 +------------
>>>  arch/x86/include/asm/fixmap.h        |  59 +------------------
>>>  include/asm-generic/fixmap.h         | 107 +++++++++++++++++++++++++=
++++++++++
>>>  11 files changed, 125 insertions(+), 371 deletions(-)
>>>  create mode 100644 include/asm-generic/fixmap.h
>>
>> Any repo/branch with all these patches will be helpful.
>=20
> https://github.com/mosalter/linux (fixmap branch)

Thanks,

For Microblaze
Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--iQtiGn9GE0PIJmOHe35N72OtEjLmxDLif
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKEmmUACgkQykllyylKDCF4AQCgjhFOcr0jquPeAeSfJ6XEBDsZ
dTIAn2jGHts/85REgK0/IHvrLywyWO8a
=ZN3C
-----END PGP SIGNATURE-----

--iQtiGn9GE0PIJmOHe35N72OtEjLmxDLif--
