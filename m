Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3F0R7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:59:46 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:44391 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab3F0R7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:59:45 -0400
Message-ID: <51CC7DA4.4040809@gentoo.org>
Date: Thu, 27 Jun 2013 13:00:04 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130520 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        kernel@gentoo.org, hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <20130627172705.GA16316@srcf.ucam.org> <51CC78C2.2020406@gentoo.org> <20130627174305.GA16661@srcf.ucam.org>
In-Reply-To: <20130627174305.GA16661@srcf.ucam.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BHQUFJRCIWQJSVEJNXMQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BHQUFJRCIWQJSVEJNXMQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/27/2013 12:43 PM, Matthew Garrett wrote:
> On Thu, Jun 27, 2013 at 12:39:14PM -0500, Matthew Thode wrote:
>> On 06/27/2013 12:27 PM, Matthew Garrett wrote:
>>> On Thu, Jun 27, 2013 at 11:47:42AM -0500, Matthew Thode wrote:
>>>> There is an early boot failure with linux-3.[9,10].??? when booting
>>>> using uefi on low memory systems.
>>>
>>> Does it happen on systems that genuinely have small amounts of memory=
,=20
>>> or only on systems where you're passing mem=3D?
>>>
>> I don't have a system (or even memory to place in this one) that has
>> that small amount of memory.  Do they even make ddr3 sodimms that smal=
l?
>=20
> I've no idea. If a bug can't be triggered on any hardware that actually=
=20
> exists, it doesn't seem like a high priority.
>=20
Dunno, I've asked in the bug for more testing from others that have hit
the problem.  I'll let you know what I find.

--=20
-- Matthew Thode (prometheanfire)


------enig2BHQUFJRCIWQJSVEJNXMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzH2qAAoJECRx6z5ArFrDKXkQAJ5hlzGoGB+r+W4azZu14pJ1
t/dSksSGFlxoidMT+624GBJ5oZ9GXkHL4/INqAnjbMrw/VBLg7Y7yvvztvArbPqn
w4g6v+MGo5mB74JBJrb5jSMv0VEpt0LV29zPpixxmncfPXkQvoVo1N+yRh1q9QVl
4Y24iIXRuPiptJr1iDK+C5tsSY7wGYiZghp1PFzh+IrMv+Guv6sVchoo4ssTkRWj
MnSkKKscFF4ilxOV10EtiL6xuOZULZYV8/Urc2G5WWJJty1VqCI9yIJLg074UaXP
TFP288metejnsLPXCCJ1H2Lqos/fRktMXDbh67zgFPnIt1vLy7t3xuqGZPOaZhB1
TVztzAHyi8p93tQ6jKDufNU9CNRjBpKmTaIOXMN70h+g3XjK4nvEHNgg2HO1pvgY
dZuJIEWARApZ9NsNWgdAG/1wNTxyryMLHmxkxQiHevlInKGc3jy/JQqsrGizh6eq
EbC8in/EhyUiR6ynHLAoi2EM0Y7LEL/PXHAVkQskSOfjaq6YUMe68VSsp5iFGsf0
Re/JQgle2SC+0yrnaT2P6c6r+8tp3A8i26G7L8LjwnidF3xjzK74wxABMDRRFn+/
soC08x0sobk9XPuwiFvsDdq2upTsUCPWVpH/6mZAoVKeTRsJ7aeWEXZyPelFqZY5
cFhc0AUkbmej/+wVAlI2
=ve2z
-----END PGP SIGNATURE-----

------enig2BHQUFJRCIWQJSVEJNXMQ--
