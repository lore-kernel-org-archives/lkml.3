Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3FDFny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:43:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58578 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3FDFnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:43:51 -0400
Date: Tue, 4 Jun 2013 15:43:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the percpu tree
Message-Id: <20130604154341.f7afbe1cf405ec6205d14dc8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Jun_2013_15_43_41_+1000_jt=SyV2ECNcNa24C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jun_2013_15_43_41_+1000_jt=SyV2ECNcNa24C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
include/linux/percpu-refcount.h and lib/percpu-refcount.c between commit
215e262f2aeb ("percpu: implement generic percpu refcounting") from the
percpu tree and commit "generic dynamic per cpu refcounting" from the
akpm tree.

I just dropped the patch from the akpm tree.  The percpu tree patch looks
like it may be a later version.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Jun_2013_15_43_41_+1000_jt=SyV2ECNcNa24C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrX6SAAoJEECxmPOUX5FEsOQP/i/sAzho44VoT8kUy/zrZoQy
/nObp2DvQ9eHLDseiaoQkOgoU30U50sM5N8idG50li7QYKjEgdx/kpe3oFE/AZ4O
uwaX1Zc6pZQwpL4cHLHInVDOLJ3MWfVYxfVm4F46QmoCjng7BPBPdTFQEnsDK+5l
anEOql/47gsJT62d5bcZjBVWok6QYpyIEPf1TTIycAOI7pxJwDFgkX7xHR41vSH2
xa/qVxCdEvMi/IJZiTSiWrM2/hqgLZMRJ4MhvKIf+Bf3n8d8RacRXsvvbKK2lZZY
YOHCiLDkZ61gcnbMwpOfuLTHfd8piyJak1ESlEagVXR3/kXQFZzvx3u0vhT1x5Sh
AVCsnnSW/YQM3B+zCT5YVxPXthTd9avRTacMSASKcv2FIAwIsGdP+SKUHxXM3V7m
OQrxmYPGpK8XWc4UeuLmGG6AZDvy3EDLBsOKCU4EHJSsZi95xibUm1ZIcDKvqBGN
aMNERLnNGxLv5k2YUTBBWwKHoEJyctn2fZHyXoVaKCD9kZ6tJve4lVmZ0fyY4g64
hTGMFtso4TEHY1pZix0UbDtnr398xKAXwkBqdIolbrJrlaNZXMAR29aZ6n/sf/6t
GfuP7krZyvZGnFra+Y7J1bTJ54cEnd6V8sba27XhlkHzi7CNe68RxbOs/HI8nVa8
FXm8GPyGzoBBB0noNeeL
=t+Ok
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jun_2013_15_43_41_+1000_jt=SyV2ECNcNa24C--
