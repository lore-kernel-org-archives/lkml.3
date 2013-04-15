Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab3DOFEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:04:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52829 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3DOFEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:04:23 -0400
Date: Mon, 15 Apr 2013 15:04:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: linux-next: build failure after merge of the clk tree
Message-Id: <20130415150402.fd83866829f3108f45b7c126@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Apr_2013_15_04_02_+1000_KMJBeA7P/j1xHBW+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Apr_2013_15_04_02_+1000_KMJBeA7P/j1xHBW+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

After merging the clk tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "of_clk_add_provider" [drivers/clk/clk-si5351.ko] undefined!
ERROR: "of_clk_src_onecell_get" [drivers/clk/clk-si5351.ko] undefined!
ERROR: "__clk_get_flags" [drivers/clk/clk-si5351.ko] undefined!

Caused by commit 9abd5f0555df ("clk: add si5351 i2c common clock
driver").  It probbaly need to depend on CONFIG_OF.

I have used the clk tree from next-20130412 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__15_Apr_2013_15_04_02_+1000_KMJBeA7P/j1xHBW+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRa4pCAAoJEECxmPOUX5FEN8cQAJy9aER5AGtGTXAeXmh9+0BY
Ip/x0k2DD48llUKYxxw4u4EO1ujWartc2Bo4KYLw3Y1kwYJtyRevOEqkHyiq3e2U
izOWCgDeTdcosXrxb2oo3HLzTBksY52OIxSOKbDxoWbi2hMPJjgfbaneFw7eD9hh
dVEqf6IFI00SzxmvbjabyWX+aY/3AsCKsufEuGt9SE4+ptWEv0IVTaR96wLFFPeB
FQZJpXNuwCa3FPlwxBrwbMcUCrjso5yXrmDdRQyikScQYC4zWvK2O3QCM/1CGc1L
hz2ydtrL6oovppcMSLj9hAEFSMCTvsjbMoH9yrUynYprLRK9f9G4cWoa7Ci+bYB5
quIej+E490jbYRHFdV/A9+fFVTOWzFO9z7J/vVqHfeaNRGhHyBYAlEI8g1moCjyB
uPZU5IQZVV14FD9w6eqGOjcc2QOp86J448c4lGXDttrziTLvpLke9JB/8W4gCGYK
9/o2nYDgSK3aHc+BU4djAzomBOehdyPNgzH6ZpSUxtZLrTQNWvMkSMq+J/+nl/E8
snolzPQWrr5C5O8hcDoH+1D26cDP0aKoF+dCxr9ZRyRLYaq2p7oRJPMTCtiSlzPv
Xi6bKyzbZkZRy0/SlqTqIvM1S/X4f1qaVg56u0atXbYwEzUICXXRgW+tlYoLl75T
mvb3Cx5+bYwi6TIr/Qir
=HSAd
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Apr_2013_15_04_02_+1000_KMJBeA7P/j1xHBW+--
