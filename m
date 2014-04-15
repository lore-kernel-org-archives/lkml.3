Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaDOBoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:44:14 -0400
Received: from ozlabs.org ([103.22.144.67]:58544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbaDOBoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:44:11 -0400
Date: Tue, 15 Apr 2014 11:44:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20140415114405.54a1f6d33f3707d785f913cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_11_44_05_+1000_xHEgKvlb_9ziyfw/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_11_44_05_+1000_xHEgKvlb_9ziyfw/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/intel/sst-haswell-pcm.c: In function 'hsw_stream_volume_put':
sound/soc/intel/sst-haswell-pcm.c:139:38: warning: initialization from inco=
mpatible pointer type [enabled by default]
  struct snd_soc_platform *platform =3D snd_soc_kcontrol_platform(kcontrol);
                                      ^

And several others ... really, you should try build testing this stuff :-(

Caused by commit f6272ff8a5f4 ("ASoC: Add snd_soc_kcontrol_platform()
helper function").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__15_Apr_2014_11_44_05_+1000_xHEgKvlb_9ziyfw/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTI7qAAoJEMDTa8Ir7ZwVKVIP/3/tectkU3l1wgSxpc0YwqtT
/DsZcVPTspZySSRnFWpzcPhK314dwlm5eZMHYo4GfpyCxZ11FA5snGty+U0Xc2cZ
IOelkjfiThSSNaF/J+e9a+yMee4yYJsdoZILt68dz1/mk7DTdgfKGUUelG6BuauX
zuuO9wInhW7RocLHuB3xEbOF0/zRbnXmGceW7M5Q1sqjGbX+7yzElk4ch92wpByI
bU8oCW8Wss28Z1naxJ7wUiivlTK3VswPRqjXFFV4FH1ZEsQ6kzaTUSM65NIZYsf/
mmIqC6k6krpCQHmOiCbaBFOjPyq1blqdXmcDr8REiCqaMeW32pTAgVMJnN8ZW2JC
UjCR4rVEvVQOkUsL0mpwGwphwjFwWvCx5MlVNBPx5xEDdj0SfnVa8jM5kS1AvE2I
jJyOoikHMlOLIcEZHvXlE+j8Kyr0mI91dFHz/UlH4szRF/DnKBphmUhNgi0UlPim
ku5bya4HwSehcTs5Jwlx1OWDQ4WPCcG7KL9fUQ2B/mNw1c5VCsTAWb1WFx+H0MTv
/7xUYOSwrn/zT3fRamt820dG0ji4NBnrm6a95JglwvMrPNmgOyGI02Oj5HnK7a4E
laa2JwQ2hTybJIl7e+zyACMON1j9e4p/wPEZH0zYYarRrkDYC4vYDSBE3CYvRZQi
SID8P0Zc2FWEso99WQyZ
=ermm
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_11_44_05_+1000_xHEgKvlb_9ziyfw/--
