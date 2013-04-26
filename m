Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab3DZG5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:57:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759684Ab3DZG5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:57:32 -0400
Message-ID: <517A2552.30808@ti.com>
Date: Fri, 26 Apr 2013 09:57:22 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20130426151027.db71ddf367c85fe0682cbff6@canb.auug.org.au> <517A1117.7000501@ti.com> <20130426155659.f203481f914edeaba9f1e493@canb.auug.org.au>
In-Reply-To: <20130426155659.f203481f914edeaba9f1e493@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9568ACAC880CA2EFD9CE51D3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig9568ACAC880CA2EFD9CE51D3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-04-26 08:56, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> On Fri, 26 Apr 2013 08:31:03 +0300 Tomi Valkeinen <tomi.valkeinen@ti.co=
m> wrote:
>>
>> On 2013-04-26 08:10, Stephen Rothwell wrote:
>>>
>>> After merging the omap_dss2 tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> drivers/video/ps3fb.c: In function 'ps3fb_mmap':
>>> drivers/video/ps3fb.c:710:2: error: implicit declaration of function =
'vm_ioremap_memory' [-Werror=3Dimplicit-function-declaration]
>>> drivers/video/ps3fb.c:712:2: error: 'offset' undeclared (first use in=
 this function)
>>>
>>> Caused by commit 6ea19860d6c5 ("fbdev/ps3fb: use vm_iomap_memory()").=

>>>
>>> I have used the omap_dss2 tree from next-20130424 for today.
>>>
>>
>> Thanks. Updated patch below. I couldn't right away find where to downl=
oad a
>> ppc64 toolchain, so not compile tested...
>=20
> https://www.kernel.org/pub/tools/crosstool/

Thanks. It compiles now. I've pushed new version to my for-next branch.

 Tomi




--------------enig9568ACAC880CA2EFD9CE51D3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJReiVSAAoJEPo9qoy8lh71l+UP/3uxcPMPOewbeFagVkHBhgoK
MphfS1ehCipIMoiDmSIZMDke9YATwsI/0nc/WEqDq5VjnZPIwadVEX+mL4gogj1H
uMG4d9BKe86oSv+XZWDEmsVEuT2q/3h7bFIu5EYIXfhswd91XhgrbEIBPOLU+Cmd
L8+9YIGRJBtV3/uRDkiiBxpI9cyEYGrLvybuWFFNyE0/I/3aCfoXM1VeH9gP1eEx
t6fzo+NJhSwdcSzWgQbIUrPiDOfbmpaawBUFXrmz25Kt0eoCkhOtqLMEsuvKlGTe
gMKut1T3BNB3iGYyRLb6R14o/uWZtgoFZibmLJF8LW1HzCQJsQOH1aWYs+/qFGU3
9MSW7vCEbQrGrUUz4O+1RtcBjm3zsG8YI1hCBWo5COzUhee5g2trpsRexGRdjjuy
OADlTg4s55C3i8wXvQvtkL+y0iUbFELUnJ81IbkWMLX+dpYCwDxo7RrcqsmhIBxX
tVA4ik6zZaRkwDQcOY8z3wlt3hr0uMN8yeVy0tK8LWSryzo8bEF7pLTo97oWYG5z
R6JsqNX/nQyyJdsrzyG8IVQKWRu+TZccYqT0+Ya/yA/u7PzGwMmT/cZ+u31GZjDC
a9n9difHK8BPrV1EZbOYsuTINvOMBfDuNk6TQnmh4Rb1hsqzW1cnGaOjTa8tenYk
tXwAhmboyf3jonp4J4Uv
=mKHL
-----END PGP SIGNATURE-----

--------------enig9568ACAC880CA2EFD9CE51D3--
