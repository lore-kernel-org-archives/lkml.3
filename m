Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaGYEi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:38:26 -0400
Received: from ozlabs.org ([103.22.144.67]:40376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaGYEiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:38:25 -0400
Date: Fri, 25 Jul 2014 14:38:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: manual merge of the tip tree with the net-next tree
Message-ID: <20140725143815.370009a8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vymejafDC.Gg0=d5.T/XQf0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vymejafDC.Gg0=d5.T/XQf0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/net/wireless/ath/ath9k/hw.c between commit 8d7e09dda821
("ath9k: save tsf in channel context") from the net-next tree and
commit 6438e0ddc870 ("wireless: ath9k: Get rid of timespec
conversions") from the tip tree.

The former changes made the latter conversions much harder, so I
effectively dropped the tip tree commit.  Please discuss with the
wireless maintainer ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/vymejafDC.Gg0=d5.T/XQf0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0d89AAoJEMDTa8Ir7ZwVcWEP/0L/MdfYTrSjdVCeLLvz0/Hx
Os+geKLwamFGHCsEs0xDEucq+V+Pgi+ES5Z+s8xwtw6AvFV1rtVj4msSLVsMy8tT
e+j8LleKZ/JShKW5u+X/ZNkZDqv3XeeTrmkV98/I4dTC8YpFBkjDaNsR7ydX+Wz2
2V4nSItb30JZJ2KPj+9IxyM3IAqkUODopwlA8/qbviif/iaqbjEk5a2ZKkFM9M6R
pDtq10N2UPYDIzpGfcrzwnGo5pNr6wlgMiF4Tof+PWtfH1Ip/65zpb+OuWH9wu1G
zdbhD9HF6zsIcSkurhvnm7VM6jDiIkfPvAuaLFXa5ywP2NYcJOFcg6OMsyCnsjAi
GYG4m1mXr3RRw99E6ILKxwbdC9pjC1fgnzzpOiymLXTl/SQWelX33yiCoCa4inAF
TedoUnStEMKoAbeze+XC3Q1Y3nR2R3JMKuD+oAJ52EmR1qSL9/kEuDOqMi1RcuLt
XQkIxTz3T5MFmvLXiE5TU2bT1Gmu2UBOCFQORd3PhieLeO5zmeuW8kOLVlC+2yk7
hibwwZnoqmlckWohckVl6zuEsMLbT8/SWwvfnYMlwKzmgs2fQsv2bPvjYNgkUCDr
ZNa/TMMu2kUze1A5UD/MJ/41ipBo8b0yia8VLYk5zijcVF6EAP1pVxhcnrQSmHMD
PBqt9gmCwUPnT9OM6nML
=7gni
-----END PGP SIGNATURE-----

--Sig_/vymejafDC.Gg0=d5.T/XQf0--
