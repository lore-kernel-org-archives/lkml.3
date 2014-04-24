Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaDXFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:25:28 -0400
Received: from ozlabs.org ([103.22.144.67]:41671 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaDXFZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:25:22 -0400
Date: Thu, 24 Apr 2014 15:25:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, Liu Hua <sdu.liu@huawei.com>
Subject: linux-next: manual merge of the akpm-current tree with the arm tree
Message-Id: <20140424152516.47a704ec9b749f98b9a93048@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Apr_2014_15_25_16_+1000_.w5EEXYkmSBrqh9p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2014_15_25_16_+1000_.w5EEXYkmSBrqh9p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm/include/asm/fixmap.h between commits 4221e2e6b316 ("ARM: 8031/1:
fixmap: remove FIX_KMAP_BEGIN and FIX_KMAP_END") and a05e54c103b0 ("ARM:
8031/2: change fixmap mapping region to support 32 CPUs") from the arm
tree and commit a665f864487d ("arm: use generic fixmap.h") from the
akpm-current tree.

I fixed it up (I have just dropped the akpm-current tree patch for now)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Apr_2014_15_25_16_+1000_.w5EEXYkmSBrqh9p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTWKBAAAoJEMDTa8Ir7ZwV66gQAIiSgQqTB/C/AqdE+9D5kE+w
aOEBoDhytroYq4QxMMRNWpHkFhhyK4cG8wb6mt5/eFq0YPcDx8nfs9x8UT1Fr4AO
yw8HlMc2xCe1uB0ssJQBYpCTIYk8Wdqeep8cJ7CfB/SGhwU7rRO6PLUIb7SbbLFT
dw8LZBigG9FEu0uCokk2agxKANr79VMfl5GnN0latUVy0FCTGopNHT8r28nTGbHs
Mo5ub7IM0RkrOMc0FqH0OHkyj6ZkQf4ryKKmVBD45noV2QLJp7ubXHsLCQajOhEc
pM1p4IRDHLMHqaEuv+7sSYmhgj2ARmZaOUIb8nFaEsMD8e9rtYCujSIlNUAlfIU3
n3xyL3WXydiP6k6ySsM/X12ddApIM34WGGe2o1R2Qfjo7cQnpbsJFOqfi12mtkFg
AHO4KVzdHnasvwDmig+Pns570sXOYjVvCG7Xe+IVXYycqWMvlVOG7iyjsWlZacV6
M0fCqNluyIg79798Wfcq1/iSW8dJTkyjs1hFcLRmaOdh9Y/QmvtpXRFXQXRAGxCf
M/mx5SIIDMFvG2ZmvvJ2/nzrP5o+AZeREaJR6uZhFu/YWWpf0OTzSlDl+6a7UHrT
YWyGik8SgltEOPDGUfx76T6gCsHYeq+DF4/lmF9VB9dJCU2lH6n3amQIVT+7x69X
lb2CTBg6uhxKbyoKJumn
=A7Vh
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2014_15_25_16_+1000_.w5EEXYkmSBrqh9p--
