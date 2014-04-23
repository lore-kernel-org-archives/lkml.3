Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbaDWHgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:36:23 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37101 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaDWHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:36:20 -0400
Message-ID: <53576D68.30901@monstr.eu>
Date: Wed, 23 Apr 2014 09:36:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, dhowells@redhat.com,
        broonie@linaro.org, benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 18/18] asm-generic: io: define relaxed accessor macros
 unconditionally
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com> <1397742261-15621-19-git-send-email-will.deacon@arm.com> <5356782A.9050809@monstr.eu> <20140423072327.GA1589@ravnborg.org>
In-Reply-To: <20140423072327.GA1589@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sBKvhTcVgXI4HURQgHNlniAPUFb9B1saV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sBKvhTcVgXI4HURQgHNlniAPUFb9B1saV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 09:23 AM, Sam Ravnborg wrote:
>> But I expect that all archs should use asm-generic/io.h to clean
>> architecture io.h exactly I have done it for Microblaze.
> I took a quick look at sparc32 - doing this is a nice cleanup.
> Thanks for the hint.

Nice. I had to fix some sparse warning which was introduce
by this change. You should check them too if you haven't done it.

As follow up we should move these to asm-generic/io.h too
ioremap_writethrough
ioremap_nocache
ioremap_fullcache - used nowhere
ioremap_wc

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--sBKvhTcVgXI4HURQgHNlniAPUFb9B1saV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXbWgACgkQykllyylKDCFBMwCgjhMefC5s9Yuk9YuliAT8VYiB
W6QAnjlN1o7TnSeXoxvr7lRiNWvjHLC7
=u2/A
-----END PGP SIGNATURE-----

--sBKvhTcVgXI4HURQgHNlniAPUFb9B1saV--
