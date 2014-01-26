Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaAZJ3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:29:36 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:46369 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbaAZJ3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:29:06 -0500
X-Spam-Flag: NO
Message-ID: <52E4D53C.3070802@pavlinux.ru>
Date: Sun, 26 Jan 2014 13:28:28 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de>
In-Reply-To: <20140125134519.GA9845@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IIDolJwgIjhdQX1XQXiRWrcBFo7JfIDpP"
X-DCC-STREAM-Metrics: ss27-so03.mtu.ru 10001; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IIDolJwgIjhdQX1XQXiRWrcBFo7JfIDpP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

25.01.2014 17:45, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:

> I'm pleased to announce the v3.12.8-rt11 patch set.

Nothing has changed, it does not boot from September, and will not boot.
3.2-54-rt77 - works perfectly. Same hardware, same config.

--=20

                                                         Pavel.


--IIDolJwgIjhdQX1XQXiRWrcBFo7JfIDpP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJS5NU9AAoJEPtok08Dny2hlL4QALwRDT7/k7TRO2/hm7trv8cC
fbCDcR1cDHGxX2cEcAqFXnUeioAeuKn8baCvqhedWx9AMXv3ekIWp/jPQtxl+BGr
SNbeR6BjGLog4bBhnw+8GHER6khxGj2Lj/rdby5Oud72e9asTnhy6ryagC68UCnH
ooRCy872QkqwcPgALXpq3FW7DnCP64DPLyqBHRJktpwqAfuwkKzVj0hvkFkmzpMk
KNoO0hU+OU0rnOORk9KiZ0i/leRsUZhg2P39vHUAkWPHadKO3PUSGiG1eC+tAPnW
GKP1WV7n8zKAlFPxJSufakESyyUVzQRNd1tESa8wGifXTfT5HDAYQYq5GnKQdDlx
jblApc0yuurO8j5FwVq9JZavAtT+Ct6YBpCs9xls4ANrjAlAXxhnt02/FLgxnVUo
tdOuooFuhP+hjtI0qraxmNxLucnUh7Uf09ldmZim/8kgKv3gMiXn1qLGRsLjYg6X
YuThnCAgF3Zj0Fe6K2AxsmJDaYrnouZKwMqOOe3qBrwo3RTevrF0vzZsbWmAEAR6
lNPW8SHjmzM+HnVGpL0l/LEHeuUDAYVTOfvyoL7RGoxgMR1ERndK+b5VfbMk/NVo
00p078E8nv8iXO62yzL689JIfbKsnr+3Z3YmPd3FvJ5sVsQ+PvDzbDwOjCm9sGoX
bLPGLpCPEzA838yIWCUZ
=yiTx
-----END PGP SIGNATURE-----

--IIDolJwgIjhdQX1XQXiRWrcBFo7JfIDpP--
