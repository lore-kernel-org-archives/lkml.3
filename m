Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbbA0ID5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:03:57 -0500
Received: from ozlabs.org ([103.22.144.67]:50681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbbA0ID4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:03:56 -0500
Date: Tue, 27 Jan 2015 19:03:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hong Xu <hong@topbug.net>
Subject: linux-next: build failure after merge of the wireless-drivers-next
 tree
Message-ID: <20150127190349.22ff92e8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7ci_J69PRRYr0IHqg+bIabQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7ci_J69PRRYr0IHqg+bIabQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

After merging the wireless-drivers-next tree, today's linux-next build
(powerpc allyesconfig) failed like this:

drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x29d0): multiple definit=
ion of `led_blink'
drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x1654): first defined here

Caused by commit 3a939a671225 ("ath9k_htc: Add a module parameter to
disable blink").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7ci_J69PRRYr0IHqg+bIabQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUx0ZqAAoJEMDTa8Ir7ZwVqWEP/0LnsS4AkRaqblf2g5KOHZVR
KPSZ0J3jm+hCyx81a5wHv6HfMY2HKQuZwBdIG2UzemK82DpbHe0do4bgg63EiYAs
bWpAEevqYZwWwOUQx4KPqV+O0YiyJnnolMhascmOL96ghadBh8TJradS9q693wps
B5mvsWDh1u9v70wYEZHtJzolN6K8qnP9iFo4OZznoa+Vwmh4ZzuBHIEArjaVUEQw
Kt/MIa7yaegY3jexJAcVUjmyGs6xKzZnL4eMTY6m19tFgV3PkIrTeUcgBoegasF6
dly95Ebvd221wvVeu6Dz4QL1XBcn+MtBcYPfkiS+7qmzLrkS0uhjy0GdFVFxeXe6
8MKqS3VgYMMXy7IMeZS4g8SyPRHRx2L7JtK+lggQiNwoDheV0JdkCIs6kjiuSR6M
smgYlZ/wo1QlzG0vFgYYsE10rewDVaz/CCSpgwsZEGUmmd+hkbhpdUJd1M48KGM7
12QDeNYi/PijSqEBOLkIMfg6yKLNpj8v+b+l00epIbfCuY5/Edj0o1P/y6VGo8Jg
78Rd2q3jxME6rWJmrdsCGcSZghmR7a12GZE/vfIexnkegSJzJhxe12khoMsPNov0
hSvEdHKzEgDkiITpAsQE6f0ISslufKWe6vTG/TvXpWbWgFbiQpfjGNzBBGAbvmBE
0Uz3HuiZqc/ewTqNZ/RB
=eKkA
-----END PGP SIGNATURE-----

--Sig_/7ci_J69PRRYr0IHqg+bIabQ--
