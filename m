Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaDEO3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 10:29:39 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:56404 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaDEO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 10:29:38 -0400
Message-ID: <5340134B.4010705@archlinux.org>
Date: Sat, 05 Apr 2014 16:29:31 +0200
From: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org> <5339F739.2060207@archlinux.org> <20140331233450.GI32556@tassilo.jf.intel.com> <5339FC62.8060207@archlinux.org> <20140405011332.GR32556@tassilo.jf.intel.com>
In-Reply-To: <20140405011332.GR32556@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ChHVkm7AeePCD7KsCKxFviMG4U7Ca5evc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ChHVkm7AeePCD7KsCKxFviMG4U7Ca5evc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 05.04.2014 03:13, schrieb Andi Kleen:
> On Tue, Apr 01, 2014 at 01:38:10AM +0200, Thomas B=E4chler wrote:
>> Am 01.04.2014 01:34, schrieb Andi Kleen:
>>>> This problem persists in v3.14, i.e. I still have to revert
>>>> 83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
>>>> kernel on i686. I would really appreciate if someone would actually =
read
>>>> my original mail from about 3 months ago and write an answer.
>>>
>>> Can you resend it please?
>>
>> It's available here: https://lkml.org/lkml/2014/1/26/22
>>
>> For convenience, here is a copy-and-paste of the full text:
>=20
> I did some experiments know and I can't find any 32bit modules=20
> that do not load with 32bit MODVERSIONS on or off with=20
> a current tree.
>=20
> Do you have a specific config?
> Specific compiler version?

Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux 3.1=
4.

[1]
https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config?h=3D=
packages/linux


--ChHVkm7AeePCD7KsCKxFviMG4U7Ca5evc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTQBNNAAoJEChPw0yOSxolYa8QANc+us6moP42uNloCY3pWN/y
mlV1ljXZZZe32R8SUWoOrVEOfJKx7Yg0ayt9qcfPI2dZ44VjnXJTPWRC0ZoFKYbI
vEHIdrQrk+Uxcrt+RG9/cKIH5GbfICUlcebI8E2Y7YCIZ2dfUJSWelQ85D7WVHn6
pIKhYKBDqOZG1ZWGLgpkpRLLD9mtr4Do/l6UXscDzMNjDS7sjWoAbgshRU1tStkV
VT13K8iXIi5gbnRehmvZh50sjGhDmaQBpcpYoJy0TTPPwDtRnrHQmskC9v3KuX49
R5CIca4wotoJDCRKzJe893XmCLy+5966d18PM+9P8tYG4XZODywU2x4gyf0dcK6W
U6m/6JmNdPLJ52/u7t47hJ7UKoxKej6XGfwoZXHp36yHGkgq+Zf5TfqOZ3HHmAZT
YEgs3KVr3dX9vimXregCweksOAjAOUgsdsTnwDBPWsjzAIj0s0BX2yLa9HV9SlrM
hPlQXXEIsWr6k+GrWfPG11JItoJ1WEr8g7/gjRkXLbRGkGqXPAD4m277p2zOWfub
7HeYRfwb8JLGRK37qdv8En2ohJYmSTGvHp0q9ky6f5P9f3wnEtIX9SFTe/kEiC9Z
HWuS+AQKAO4xYp20vBTrCgSgZYdqCNfZ6hNyhxyIACsZojBbcvy9WvlVH038aQB1
vx2XtPdspuRUhJzGlxD4
=nPLS
-----END PGP SIGNATURE-----

--ChHVkm7AeePCD7KsCKxFviMG4U7Ca5evc--
