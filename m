Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3D3MBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:01:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759863Ab3D3MBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:01:16 -0400
Message-ID: <517FB285.7030903@ti.com>
Date: Tue, 30 Apr 2013 15:01:09 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: <balbi@ti.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: Kconfig "softdepends" idea
References: <517F9472.2030106@ti.com> <20130430102440.GA15522@merkur.ravnborg.org> <20130430103318.GB12161@arwen.pp.htv.fi> <517FA68B.20001@ti.com> <20130430114004.GA15804@merkur.ravnborg.org>
In-Reply-To: <20130430114004.GA15804@merkur.ravnborg.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2XFDGKPHQPHCNSIDNXGBR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2XFDGKPHQPHCNSIDNXGBR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/30/2013 02:40 PM, Sam Ravnborg wrote:
>> SHOW_ALL_DRIVERS" is not very descriptive. I'm not sure if that matter=
s,
>> though. One doesn't need to read the Kconfig files every day =3D).
>>
>> But presuming most of the drivers would use that, it would add quite a=

>> bit of repetition to the Kconfig files. Well, ok, I have no idea how
>> many drivers have dependencies that could be removed.
>>
>> So SHOW_ALL_DRIVERS sounds quite an easy solution to this.
>=20
> Someone suggested to add symbols that are only set yo "y" for allyescon=
fig or allmodconfig.
> This would be what you actuayl require here as what you are after is be=
tter
> build coverage.

Sorry, I didn't quite get this. Do you mean that if I do allyesconfig,
SHOW_ALL_DRIVERS would get enabled, but not otherwise?

> But we should not annouyt the user just to get better build coverage - =
which
> is why hiding irrelevant symbols is good.

No disagreement there.

But I must say good build coverage is also important (I broke a powerpc
fb driver compilation with my mmap changes, and after fixing the
compilation I introduced a warning...). So I think it's a worthy goal to
have most of the drivers arch-independent, and make it possible to build
them if the user so wants.

I'll do a bit experimenting with fb drivers to see how the
SHOW_ALL_DRIVERS would work. And if there are any other fb drivers than
omapfb that actually can be compiled on other archs.

 Tomi



------enig2XFDGKPHQPHCNSIDNXGBR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRf7KFAAoJEPo9qoy8lh71uWMP/j/1oA01EAODKZ7pk54xJNg9
T3IiY+qzx93yX/Jj7jEfiB/bNhHstKZSg9o1iVTskn4RP8Drdk4R3PerYdmhZas9
ikbDKzXaslKpn4Xhin4vQ5cBRcgzxAb4VWLyELyjnunsEOTCz8ce8m/EOpWkIfvt
zSfeDfIKS2z+KPZMMSqTjEMPZTMBUfKMdX7r553WeHFiqcHJ2NqC/uu3ck5O7Kys
gv8aP2ncSsU+KGkGk+klsoE7XW7j6p7Qy98SAOC3J1OLYGbBTtRo2G8lB2OnMDUc
Dzcvt7MouTd0yRWq0smIc0BbiaosN1WmG1aAqgbnyf4Tbw+QIa5xfFxNx7BwdIAP
VBWOqqltbUV3jXv/xn1WH20M6nJMn2TQxznaaf6eJVq0ma40EV0zqOEzETbmn6fo
gmeIHUzjSwn6B6gUF8ZJCCBAYvqRHyEAk2SpNKojNgVdttnWZy8Ex9rsMucjWc46
iHTu8Si5n9okx/QU9wOe6ScKE69jzLc0AeiPa4+z6yN2feT69HVEWOoGUoLx3111
QPcuF8cqzoLfDuSF+1tXZC66DhNhk23jF0etzjKTwGV+fm0YPu7h58S87Fqxz5P/
o2nX1NJCP1K9CHKHneLV1vw6MScdm3F6lYLYIQBZC5vd+ZQARC8qUEqGmtsU9PGU
dqvQlINkFBqnx1eJun5v
=XF85
-----END PGP SIGNATURE-----

------enig2XFDGKPHQPHCNSIDNXGBR--
