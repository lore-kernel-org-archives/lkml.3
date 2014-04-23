Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaDWHMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:12:41 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63254 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaDWHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:12:40 -0400
Message-ID: <535767E4.6020900@monstr.eu>
Date: Wed, 23 Apr 2014 09:12:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 18/18] asm-generic: io: define relaxed accessor macros
 unconditionally
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com> <1397742261-15621-19-git-send-email-will.deacon@arm.com> <5356782A.9050809@monstr.eu> <20140422151809.GF9820@arm.com>
In-Reply-To: <20140422151809.GF9820@arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fLllnNn7PTSF7DuVVvuSibNHt1oOdS2HU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fLllnNn7PTSF7DuVVvuSibNHt1oOdS2HU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Will,

On 04/22/2014 05:18 PM, Will Deacon wrote:
> Hi Michal,
>=20
> On Tue, Apr 22, 2014 at 03:09:46PM +0100, Michal Simek wrote:
>> On 04/17/2014 03:44 PM, Will Deacon wrote:
>>> Now that no architectures using asm-generic/io.h define their own rel=
axed
>>> accessors, the dummy definitions can be used unconditionally.
>>>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>> ---
>>>  include/asm-generic/io.h | 18 ------------------
>>>  1 file changed, 18 deletions(-)
>>
>> Do we need this? I think there could be a need to overwrite them.
>> Currently we are just lucky that architecture which uses asm-generic/i=
o.h
>> don't need to overwrite it.
>> But I expect that all archs should use asm-generic/io.h to clean
>> architecture io.h exactly I have done it for Microblaze.
>=20
> I'm open to keeping the conditional definitions, but it introduces a
> discrepancy with the non-relaxed versions, which are defined unconditio=
nally
> (although the underlying __raw_* accessors can be overridden).

up to you.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--fLllnNn7PTSF7DuVVvuSibNHt1oOdS2HU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXZ+QACgkQykllyylKDCFSJgCgnNdIsl0aqV2eq561vp8vMmeK
LKMAni1uuUWTcvoV1akrZQyc7LaAQjVQ
=O4wg
-----END PGP SIGNATURE-----

--fLllnNn7PTSF7DuVVvuSibNHt1oOdS2HU--
