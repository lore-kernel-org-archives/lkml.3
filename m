Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3EUE3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 00:29:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3EUE3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 00:29:50 -0400
Date: Tue, 21 May 2013 14:29:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the akpm tree with the net-next tree
Message-Id: <20130521142948.444f09820c5406f9adc4b7f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_May_2013_14_29_48_+1000_4/=ttzL7bsxOqXhl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_May_2013_14_29_48_+1000_4/=ttzL7bsxOqXhl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm/net/bpf_jit_32.c between commit aafc787e41fd ("arm: bpf_jit: can
call module_free() from any context") from the net-next tree and commit
"bpf: add comments explaining the schedule_work() operation" from the
akpm tree.

The former means that the latter is no longer required, so I used the
former and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_May_2013_14_29_48_+1000_4/=ttzL7bsxOqXhl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmvg8AAoJEECxmPOUX5FEcxcP/R5kp5LVV7+fXRy7XnNNvmEm
PQgEjo8PZ+Bsxb2AcfgBJoN8lTSdLDEfLMY56wPlM9YfJAmYG2IA0vEJABONU/mY
STU19wehQDnf4y5ubgexkghP4XuicIJzAEGWfQYyhQUDS+aEszla+59bUIGL273i
SpwhvRIMGDQ4xkEDGE15I7jF5gNZT8XKgs/gwskAyZuKKoX6qpMBf+BtoPnY4DLx
2kTxxnMeTpRF5yVYUSVESkfUDRpQ9YEf0UuobXVrJIlEXKPlqsDeRHtgVEWpV5qQ
wwYKxB+BAa/Ylz4U7/NIbHLCKjF4RsMCFltPYPWXqPZyPI4Gc15DUiRQYb+k6UUW
thuPgEqmfi/vZjpZgOQp6n31RxioalmN2AgVS87Az7QrnWbeLNR0RieAshLDHKCf
zxQqnmUst6gBv4kEnLsxRMDDd2PNz7kKGHIKn4FfAfok6yCOn1LyigCdoCQfQTpr
GNWabKjfeKennXuXomDSfnLNmt6b2Fs/SH/X624LZ0KKJAtcaewCwG+xHfnc4g06
rd6SfNJi96YDSdQ9TT9G9NKnNpyGuuTbUAV2FWyIBknIbbAYRAkCtAGAam2K7XLn
w9znL2seizlrbCFdA5pb89AOWIkn823lxPZ94DmiJh0f0PZOH32gtI4qELqzB8gq
5HgJGLTmpQ7EHWZDarZI
=8ZXz
-----END PGP SIGNATURE-----

--Signature=_Tue__21_May_2013_14_29_48_+1000_4/=ttzL7bsxOqXhl--
