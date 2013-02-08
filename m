Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3BHA5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33502 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3BHA5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:18 -0500
Date: Fri, 8 Feb 2013 11:57:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130208115708.33af567496b8aeb8ca6b30c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_11_57_08_+1100_c_YhssDQnANd5Z0L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_11_57_08_+1100_c_YhssDQnANd5Z0L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/soc-core.c: In function 'snd_soc_dai_digital_mute':
sound/soc/soc-core.c:3555:22: error: 'const struct snd_soc_dai_ops' has no =
member named 'mute_stream'
sound/soc/soc-core.c:3556:26: error: 'const struct snd_soc_dai_ops' has no =
member named 'mute_stream'

Caused by commit df6dc7a26e7d ("ASoC: core: Allow digital mute for
capture").

I have used the sound-asoc tree from next-20130207 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_11_57_08_+1100_c_YhssDQnANd5Z0L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFE1kAAoJEECxmPOUX5FEaI4QAKLn/zUXMpIp2PZ12HM1VJkg
NXQGUFR2u5xq4NfW6Snz38+RCoYLQKqe9LFsous5ZH8XvM5YmurdjGc5yvYoB82I
dmnJjxj2JH3kgj42ICnrQbtDDgTVhCF3WyaPuRFYvcepRdu62/9E+G9WpQgLZVLv
SHsi3RRpF3MpDuLGOMaj4zDy17FGN975FD6RZ39yZQ1g2OLPUVWEkt1ty7nDGeXy
C8DMANjWrcnbfFB/hZfImsoj6PGP/eXNkOSlEAb+HQP9POqnYeYwKptCMt5YFn2/
JsaapLqY5wuDT/BXrQreyStWR3avEjmOssSpA/pHpDuIjhzP5Eam0FMeZsE0K5/M
ysU05po64VdmpAyTpVh8LE2T3XdY1wU7yUohvqMEYxYdb/7oOyUknD7fac2wLUXZ
svudfbe+HggMTgNi+AKIooi/1M7TWwv9dNWNgd1bjubol3g8tpl91YRd+D/UdKuM
RuqYs5Vz3y6iLvxbzzApDJdynjPc0NUBVGecq5vWDEkyjg+unzKCExOVEslyaU7M
MIbtZaROuNgN4ABo8jrhvuvhwjFfMUtxuXTsH3Fm3YRs7DCiG25STqRHey25XrbF
CqODpi5DGpdLKgW5sywYpm0v2a2z+uEVvAToc1R9nKGG7GviYxhU+9OzAGt1o3mX
dPsyAFFQD9d6YZeerfhi
=RNvT
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_11_57_08_+1100_c_YhssDQnANd5Z0L--
