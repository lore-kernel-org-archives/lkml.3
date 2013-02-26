Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab3BZHHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:07:24 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:49315 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3BZHHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:07:23 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2013 02:07:23 EST
Message-ID: <512C5D6D.1040509@gentoo.org>
Date: Tue, 26 Feb 2013 07:59:57 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig
 dialogs
References: <512A36BB.9070309@gentoo.org> <201302251930.22293.yann.morin.1998@free.fr> <512BCA76.6080601@gentoo.org> <201302252153.39465.yann.morin.1998@free.fr>
In-Reply-To: <201302252153.39465.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2GTTIMSATKCOVSELBJMUN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GTTIMSATKCOVSELBJMUN
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 25/02/13 21:53, Yann E. MORIN wrote:
> Justin, All,
>=20
> On Monday 25 February 2013 Justin wrote:
>> On 25.02.2013 19:30, Yann E. MORIN wrote:
>>> On Sunday 24 February 2013 Justin wrote:
>>>> when ncurses is build with --with-termlib several symbols are moved =
to a
>>>> seperate terminfo library (libtinfo.so). Current Kernel buildsystem
>>>> results in a build error with menuconfig and nconfig dialogs.
>>>
>>> Do you know of a distribution where this is the case, so I can test?
>>
>> This is using Gentoo Linux testing with ld.gold. But I assume you will=

>> get the same result using any distro with gold.
>=20
> No, I meant a distro where ncurses is built with --with-termlib.
> On my Debian stable (squeeze), libtinfo does not exist at all,
> so I can not test linking against it:
>=20
>     $ apt-file search libtinfo
>     (zilch)
>=20
> But I'll see at installing a Gentoo (if that's not too complex) in a
> VM to do the checks (can you confirm that Gentoo by default configures
> ncurses with --with-termlib ?).
>=20
> Regards,
> Yann E. MORIN.
>=20

I can be build optionally (mostly for binary package compatibility
reasons) with --with-termlib. I will send a step-by-step instruction how
to test this with our live cd later today.

Thanks,
Justin


------enig2GTTIMSATKCOVSELBJMUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEsXW0ACgkQgAnW8HDreRZngQCgmKHuhD4uhyK8yNVeEF0aXB4M
fhYAn1Db/a6XgMP2YLilQKWlLU8jWD3y
=7FBe
-----END PGP SIGNATURE-----

------enig2GTTIMSATKCOVSELBJMUN--
