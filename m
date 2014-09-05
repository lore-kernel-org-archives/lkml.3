Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaIEVko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:40:44 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:58691 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIEVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:40:43 -0400
Message-ID: <540A2DD1.1040002@gmail.com>
Date: Sat, 06 Sep 2014 00:40:33 +0300
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, ron minnich <rminnich@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        coreboot <coreboot@coreboot.org>
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com>	<540A17A6.1000802@zytor.com>	<540A266F.80503@gmail.com> <CAP6exYJj8Fupa1uTLRP5uGoWNjvwKo7bAAPvYmzUYB=AOqOq8g@mail.gmail.com> <540A29E6.2080405@gmail.com> <540A2B9A.1070707@zytor.com>
In-Reply-To: <540A2B9A.1070707@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tX4xTpULJtHKD6nCvtf708uFBIEofL5nG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tX4xTpULJtHKD6nCvtf708uFBIEofL5nG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06.09.2014 00:31, H. Peter Anvin wrote:
> On 09/05/2014 02:23 PM, Vladimir '=CF=86-coder/phcoder' Serbinenko wrot=
e:
>> On 06.09.2014 00:18, ron minnich wrote:
>>> Vladimir can you point me to that patch? This sounds
>>> interesting.
>>>
>> https://lkml.org/lkml/2010/8/25/190
>>
>=20
> I believe *most* of this patch has already gotten merged as we now use
> simplefb on x86 as well.  So all we need is probably the ID.
>
Yes, efifb has the same semantics. We just need some ID with clear
documentation saying sth like "implies framebuffer without anything
else" so that noone will get an idea to plug e.g. vga hooks into it.

> 	-hpa
>=20
>=20



--tX4xTpULJtHKD6nCvtf708uFBIEofL5nG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREKAAYFAlQKLdIACgkQmBXlbbo5nOsmCgEAoQgTTdrMy9PiFQcSVanKzQHb
R6Avj5k5GVFjIsrd5q8BAKLAfl/tdUroQzASUWCvRaREidXeMCpEf5WJH8RBYpPV
=p7VD
-----END PGP SIGNATURE-----

--tX4xTpULJtHKD6nCvtf708uFBIEofL5nG--
