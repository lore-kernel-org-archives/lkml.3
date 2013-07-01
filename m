Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3GANFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:05:04 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:55232 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3GANFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:05:03 -0400
Message-ID: <51D17E8F.3020500@gentoo.org>
Date: Mon, 01 Jul 2013 08:05:19 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Luca Barbato <lu_zero@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org> <20130701051320.GA6840@srcf.ucam.org> <51D11218.5040601@gentoo.org> <20130701062530.GA7423@srcf.ucam.org>
In-Reply-To: <20130701062530.GA7423@srcf.ucam.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WHDOVTVUEREWNSINLQQN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WHDOVTVUEREWNSINLQQN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/01/2013 01:25 AM, Matthew Garrett wrote:
> On Mon, Jul 01, 2013 at 07:22:32AM +0200, Luca Barbato wrote:
>=20
>> MacBookPro8,2 with efi-stub, loading directly from the efi shell w/out=

>> any memory restriction.
>=20
> How do you know this is the same issue?
>=20
Same behavior?  Can't really know until it's solved I think.
Unfortunately this bug seems to cause a lack of info.

--=20
-- Matthew Thode (prometheanfire)


------enig2WHDOVTVUEREWNSINLQQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0X6WAAoJECRx6z5ArFrDD1YQAMKV/XtpyeG5VkPDok8fqHiZ
e3jk4dZ/1CeUxcnia46whEEyjX3zThKay/WKovuPxNg34LGqDBeBjx+VzF8Q2obS
a2PGT3Zx4IWbTc1MgapCvI7uv0cEy1QNaSAV/O/DMFMcippmH8ObzE2krwiGMCkd
AxDyPvp+8+yB/QFC4qt9192PYg1y7Bb/dTf+92xpEFsKoQlhvsKzdLVshyWAN08v
lt95vYxlgEvvZmlZDojw9XoxvOW56P1QAANZ23b2co98xAWxCtLkfD0mgDXMwksN
nz99pBjnc2T+gURLhyo3rt5fXXNixCg78p0q02td4jEgXB2rlpbODqRRAiFgSmt+
NQ+30dt8NtbI8JciATaIJjSZqzxay2wXYEXmSyFXnCNB9u1/AwMkj6vEPRJwliLK
N4ktEr/qV9vwsULnOt1AI4V6XGeKpebz3m6WS+bmUezGqDiOI5kN+Nlfh50JdNRv
V7Vw2t1PnVK9emf/mli7gFIZdx97/3d8iNYuU7zbJSMqwyQPMN9s2z//v4BKgBz6
XvBibcISjIyjKYMepA0fmopEpTTwy6986SFkiCXajlxOHRnJ0RKpz0fYX5wiZgzA
i61LgInHcXYVrS77KS7Qk9Y6W1wpfrWy53hWobkkLoPqaB4SQkoo4QHW2RIRDmJu
PnZ99F5XMo8j9NWaYVOW
=dz9X
-----END PGP SIGNATURE-----

------enig2WHDOVTVUEREWNSINLQQN--
