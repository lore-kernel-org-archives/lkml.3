Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaKRVEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:04:23 -0500
Received: from ozlabs.org ([103.22.144.67]:43783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbaKRVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:04:20 -0500
Date: Wed, 19 Nov 2014 08:04:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commit in the nfsd tree
Message-ID: <20141119080411.09f6a811@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lZahKQVJ53uKVryF_+L/dtP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lZahKQVJ53uKVryF_+L/dtP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I just noticed that the top commit of the nfsd tree (be603bbb7bc1
"OOPS") has no Signed-off-by tags (or a real commit message at all) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/lZahKQVJ53uKVryF_+L/dtP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUa7RQAAoJEMDTa8Ir7ZwVBScP/RhYnFMd95kMlAKncL0sSYjZ
RIkZ6SolmE8jfpq6k4+i4rWf8IzkUH+44y/DR2N3NFUvW61s2qEwIUNjiGMsRWLa
NLi8GjwBHHkTf2slGA/hqxLM4NEqyr3Vgm1bgjkrog1w4JZi+C8j9cZq3ThmvMub
uqMs+wFjuTFW9Q3oCNDYFfTuhXhkgvk069VJcDZkf5kvnS68Nhupa60qmXv0eCPi
VQNM/XT663QA1ebblrMFsHUYoL7xfXM5iuiO0y/dFyfmiEH4x2sEFsf8vGOUFPiF
m3oysgBu0YkbM7anMiqJT7KUECU9Scav9rZm/xCL1bisiF/tU14ZK6UpUgOshorG
2qw+CjP1ACK1bVW4kGBr886wZS2NgGBxRa6n8Ywqyjz8p8QkSfLNEBaZpRHwjM1D
oebRZZY5C0+zXgix8j19aZATpoB1DdJGAsB56iivUMdSjQE0FnYVlrOF7flwmPJN
BQ/z+0nn2Yabf2i9bhuxzydkqyy4OD2xF0n8i/H/4n2+5O33smYJ5PQH57mwPtGg
yYJlo8H92GwibEQ9j6Q4WPM+Wj5kHu3Bnjj87SVIMb2paape1ADU7hKErjY6BsBE
VHFmgX1gNksuU2oAx4O5lfGAJ3o6WXfl9U+lEbofXRY3M01Z0eLiB2AnfzDr3yPX
1n1b+HTb9uKtW722doFs
=Ulze
-----END PGP SIGNATURE-----

--Sig_/lZahKQVJ53uKVryF_+L/dtP--
