Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaFQI4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:56:49 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:15196 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaFQI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:56:47 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4xBpp8qgihxczpINJ3w6w9yL3SuQdkCDxWLQMWA
X-RZG-CLASS-ID: mo05
Message-ID: <53A002C8.8090702@samba.org>
Date: Tue, 17 Jun 2014 10:56:40 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: =?UTF-8?B?QmrDtnJuIEJhdW1iYWNo?= <bb@sernet.de>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
References: <1402394606-7910-1-git-send-email-bb@sernet.de> <539EF5FD.5000307@samba.org> <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
In-Reply-To: <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Steve,

> Although I have merged this into cifs-2.6.git for-next, in my testing
> I am also seeing this fail with vers=3D3.0 (and probably 2.0 and 2.1) s=
o
> I would like to fix that too (and mfsymlinks may be at least as
> important there)

Thanks! When can we expect this to be proposed for 3.16 (and stable
3.14/3.15)?

metze


--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOgAssACgkQm70gjA5TCD++uQCdE1x35nZppVuyjjgo69ZVZ2jU
rKEAoJ1Q2V5++AQv+G4fTbEotRqpK6wt
=iAqo
-----END PGP SIGNATURE-----

--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76--
