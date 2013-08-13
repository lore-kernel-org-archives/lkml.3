Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3HMNXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:23:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63731 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab3HMNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:23:07 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
Date: Tue, 13 Aug 2013 15:23:03 +0200
Message-ID: <3393485.1SLDJRVlAS@pali>
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <520A2E1F.2050307@labri.fr>
References: <1836330.fGgIDqPTNA@pali> <520A2E1F.2050307@labri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart15824028.gvuxnzj4HZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart15824028.gvuxnzj4HZ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
> On 13/08/2013 05:56, Pali Roh=E1r wrote:
> > Hello,
> >=20
> > after commit ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954 temperature
> > information from lm sensors is not available on my Nvidia 6600GT gr=
aphics
> > card. There is no nouveau hwmon entry in sysfs anymore. Why it was
> > removed? Can I help with debugging? I'd like to see temperature sen=
sor
> > working again.
>=20
> Hi,
>=20
> Thanks for bisecting the issue. Can you send me your vbios and tell
> me if the nvidia driver shows your temperature probe (and what is
> its source).
>=20
> To fetch your vbios, you can extract it using nvagetbios from the
> envytools repo: https://github.com/envytools/envytools
>=20
> Cheers,
> Martin

How can I check source and temperature probe in nvidia binary driver?

--=20
Pali Roh=E1r
pali.rohar@gmail.com


--nextPart15824028.gvuxnzj4HZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIKMzcACgkQi/DJPQPkQ1JoCQCgwOmDwdwd9IdxUExbCMRuMyMG
VjgAn0b2e/H12uB9UE5/uBNAnStpfV/H
=1FOp
-----END PGP SIGNATURE-----

--nextPart15824028.gvuxnzj4HZ--

