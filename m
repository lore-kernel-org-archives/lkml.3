Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbbAMFtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:49:12 -0500
Received: from ozlabs.org ([103.22.144.67]:50335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbbAMFtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:49:10 -0500
Date: Tue, 13 Jan 2015 16:49:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, Leonid Iziumtsev <x0153368@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gigi Joseph <gigi.joseph@gmail.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Amir Ayun <amira@ti.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Message-ID: <20150113164903.2dc0a2ce@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oswKB+rSAMR1T9av.5FpMcX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oswKB+rSAMR1T9av.5FpMcX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/misc/ti-st/st_core.c between commit 0ec0cf19201d
("drivers:misc:ti-st: protect against bad packets") from the char-misc
tree and commit 55ed078edf3f ("drivers/misc/ti-st/st_core.c: fix NULL
dereference on protocol type check") from the akpm-current tree.

I fixed it up (they were doing the same thing, so I kept the former as
it has a nice comment) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/oswKB+rSAMR1T9av.5FpMcX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtLHTAAoJEMDTa8Ir7ZwVrv0P/0Yyw7qHkvBz04BMt6T+96u7
wuTlcAIXYpf3ND9q4w6utt3ephFjlyQhA2ZSzvE/OcWhzaroyzs0vJ72IqaiL668
hM6chA5bnrda/TuTz0wvci8NXcN7R5KqYoUiifhO2AS//PIN324sX0rzr1UoUxgJ
/EbOmc/VUYIEY/eoYxvAieLvcMsNo/pn0FRJ1Gpy01vfkDFxy5q1mCzvf0bAPBdp
x9axfJAfVf5TjKtvHWYYcfBOeXAE7Z4L8l4X/Ct3W3G4EDxhk9dfLXGn6pIXoPqj
MVLhRmelMAeNRM/d0jyjpG7hl86vKSeHrsRZewgG4UioQNSL/IYReCKzdPZ3ae22
5icX5HbC8YSr7UTufCTN8PNtFubV2e5BatZ+9kJ6VqddfZmNvghHMvZRTPA83Ja2
Q/jf+SumT4wVF8TRf3kfaauvjvm/FXpecwjDdPZTrz+XYYrPt1XsObTQhiiM3YWi
6tdZkzL68+LTnv37er6w++f2uHWoLj0TxM6HXXZSh9rC3LFz4R7UMCxBSRgRJSLe
r+GqQ5Oe2gRFJyJlRYSWCCY5/8XcgT+tlLVDZNwT1AcTNQFN/4L1SIu82qLz7vBq
2T2oVdHx3mUufiMGHdC2Nq4W57q7flgudNvymwyiQYzZVEkCsep6B/W1k+vEHFwN
CqOFrvZsig8itC/sWjZE
=EkOQ
-----END PGP SIGNATURE-----

--Sig_/oswKB+rSAMR1T9av.5FpMcX--
