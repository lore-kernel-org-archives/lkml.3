Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbaDIIal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:30:41 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:39318 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbaDIIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:30:39 -0400
Message-ID: <5345051C.2060104@archlinux.org>
Date: Wed, 09 Apr 2014 10:30:20 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        =?ISO-8859-15?Q?Thomas_B=E4c?= =?ISO-8859-15?Q?hler?= 
	<thomas@archlinux.org>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, matt.fleming@intel.com,
        ak@linux.intel.com, viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <20140407173016.GU32556@tassilo.jf.intel.com> <5342E46B.4080603@archlinux.org> <53430646.40507@archlinux.org> <20140407204221.GW32556@tassilo.jf.intel.com> <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com> <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp> <20140408121400.GI5222@console-pimps.org> <53444681.1070902@archlinux.org> <53445660.1010908@archlinux.org> <20140409082536.GJ5222@console-pimps.org>
In-Reply-To: <20140409082536.GJ5222@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NeJevX1g79je66hUIqPIkfp5uDRKLunUW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NeJevX1g79je66hUIqPIkfp5uDRKLunUW
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 09.04.2014 10:25, schrieb Matt Fleming:
> On Tue, 08 Apr, at 10:04:48PM, Thomas B=E4chler wrote:
>>
>> Hello again Matt,
>>
>> with linux.git master, I cannot reproduce the problem at all (with or
>> without your patch). In fact, all the 0x0 CRCs on symbols are gone, an=
d
>> those were the symbols that were broken after all.
>>
>> FWIW, with your patch the kernel still boots.
> =20
> Could you try this version? It's against v3.14,

I'll do that tonight and report back (now + ~10 hours).

In the meantime, I figured out which commit fixed the 0x00000000 symbol
CRCs in 3.14+, making this bug invisible - it was
dc53324060f324e8af6867f57bf4891c13c6ef18 in the Linus tree.



--NeJevX1g79je66hUIqPIkfp5uDRKLunUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRQUpAAoJEChPw0yOSxol340P/jRbtdRcBFIrW20TFEWEg1co
BrhqvYJIE/Dxm8XpiC5W8Ff4YO+upyjyo/2f+IKrS89EgWg+KgTlntbCET7wmhV8
o7gd6G5NFZAb2pUuenBavMgr6nTJIRO7Payhf/lgBU0uSD8S7B/+tGSwfuj51r5/
fgZi/zejU5Q5fy5pHpU26/4KvuAZ/tpasT705NZzi6BtBPN/oOUVjZDuhbMby0Qj
fRKxfojmFzGIORlyASdcSfKdc2q+7UlGk7G5PTLfDZ6h1yTvUBAV0T1m+hc0kUf8
LQEdQwR3MrNa3y0nfpUU4QPxRz0Xo5f04lAqXH2YHyMQswsHweah+ltEm0vu+a7g
GV02Z8QEqMRIeA8Geyx4SEU4JAaoslnj5LGgj07MYjSSCo47UrCWNj1hg+DIm0w2
qhxS0FQuD4YQCPYtdN/ZLO2k0cyfn7wmNc+HKCT+gZQsiZTegyrarw2uhs6SCDO/
5Z7Mt7Z9ntH5oH6Rn+WcFZu/GFM1kAafFizEhjCM1UAFD4J6FECRdi+s5EXODAcL
PF/MNRCl4JgXhTXIDz3dIqsUg/mRWaEbO2wRhaaj0ELInZ+3+WrakliPrt4c2FKJ
6l6m+z78GDNUwW+MgDqCpn3nT+Dkp7c3Zvzd/1qzrg+A8dpwuJuVEBUJAP7bY/nM
N+tjvukQqSkyZvAY6pYZ
=EQwU
-----END PGP SIGNATURE-----

--NeJevX1g79je66hUIqPIkfp5uDRKLunUW--
