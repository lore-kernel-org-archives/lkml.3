Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaA1HyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:54:00 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:40278 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaA1Hx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:53:59 -0500
Message-ID: <52E76205.4080903@archlinux.org>
Date: Tue, 28 Jan 2014 08:53:41 +0100
From: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, thomas@archlinux.org,
        ak@linux.intel.com
CC: viro@ZenIV.linux.org.uk, geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org> <201401262322.DDF78613.FVSFOLOOJFHtQM@I-love.SAKURA.ne.jp>
In-Reply-To: <201401262322.DDF78613.FVSFOLOOJFHtQM@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FBpTJ0p1gQ6oL3GOn5op5qANvJNF2R8Wp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FBpTJ0p1gQ6oL3GOn5op5qANvJNF2R8Wp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 26.01.2014 15:22, schrieb Tetsuo Handa:
> Thomas B=E8=87=98hler wrote:
>> This looks exactly like the problem experienced by Tetsuo Handa in [1]=
=2E
>> However, for me, his solution, i.e. setting
>>  CONFIG_PHYSICAL_ALIGN=3D0x1000000
>> instead of
>>  CONFIG_PHYSICAL_ALIGN=3D0x100000
>> doesn't help and the symptoms stay the same (and, according to the
>> documentation and to Kbuild, both are valid values on i686).
>=20
> I tried your config with "make localmodconfig" and saw the symptoms. I =
changed
> CONFIG_PHYSICAL_ALIGN from 0x100000 to 0x1000000 and no longer see the =
symptoms.

No idea why this worked for you. Anyway, if
CONFIG_PHYSICAL_ALIGN=3D0x1000000 is necessary, then Kconfig should
enforce it.

And none of this changes that symbols without CRC are a bug.

> Did you save your config after changing CONFIG_PHYSICAL_ALIGN ?

Well, of course.



--FBpTJ0p1gQ6oL3GOn5op5qANvJNF2R8Wp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJS52IIAAoJEChPw0yOSxolAcsP/iB/gWqUi/gjMzhB+G0o/n05
Q+CbhJlZhWrzd5DtI/Ofit6EeXwlrvNrt891X14pGYODBF26ItKepbnklXESpuqK
ZQFHUxxNgWG4QD78Vp6fdMlie3jUXb6R4Soie9s6rjPhYZUVo9yJarFxESMvSHCY
SQYSdr8sFJWU8NKoPDrgf7+A2eg5xRYnZdlpUpdhaEJx+IRG84Jx2f4hr4zRkTJL
lN1H3GHEBSLHMscZb4kQNIoDs+hroZvpWqCbEyUjSKwXYyA1LJVwupRggoobc+oa
V8fyjGt1/X6inAQhRzQSeWCqHKY9t/8S1jE8dF75rPqUwk3It0SdYLxo7NSka19x
5KIf8i8tavhq3hcBWLdr3MWTy9A1LXoCiYGa1UDQlTnrfQCs0aODCB/eHq75xXez
k7kivDJSmtAzUf/lPKSCQsiqkzlFwnGthSuL0euhUVrMAdgNEXARhByk0nCyF7s/
SB9gyYNgQ0WbIYztSWoklJm3MCtwPJiaq4OmW7taa1Tq/jSetuHajID+LlSu22lj
7OFlGtiMSddsjD7Re6XoyK9iNt9+HtVyi15nHzolF55OpPGwwXZuhBX0nRUyfUxl
gmOTxTOJ7QBJpSGiWoXjwgpBUX7C9/syQfExCrLdnhA+HGJ/8GfJxJjH6N7g+ROH
fD5jqCKNki8EUcxNG+hB
=D3Gs
-----END PGP SIGNATURE-----

--FBpTJ0p1gQ6oL3GOn5op5qANvJNF2R8Wp--
