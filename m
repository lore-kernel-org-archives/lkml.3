Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3HMJ41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:56:27 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51830 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3HMJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:56:26 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Peres <martin.peres@labri.fr>, Ben Skeggs <bskeggs@redhat.com>
Subject: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
Date: Tue, 13 Aug 2013 11:56:20 +0200
Message-ID: <1836330.fGgIDqPTNA@pali>
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6955043.SWBY91aTGU"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6955043.SWBY91aTGU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello,

after commit ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954 temperature infor=
mation=20
from lm sensors is not available on my Nvidia 6600GT graphics card. The=
re is=20
no nouveau hwmon entry in sysfs anymore. Why it was removed? Can I help=
 with=20
debugging? I'd like to see temperature sensor working again.

--=20
Pali Roh=E1r
pali.rohar@gmail.com


--nextPart6955043.SWBY91aTGU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIKAsUACgkQi/DJPQPkQ1KbRgCfZXerdvd+nOstFSKLnU4De+XE
UOQAoLHXLwX93hQuzMVT08zWUfX2e8in
=01z0
-----END PGP SIGNATURE-----

--nextPart6955043.SWBY91aTGU--

