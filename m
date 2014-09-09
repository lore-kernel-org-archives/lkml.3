Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaIILVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:21:48 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:57448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756142AbaIILVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:21:46 -0400
Date: Tue, 9 Sep 2014 13:21:38 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: arch/microblaze fixes for 3.17-rc5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pQ43GaAP8wnQJglTV84u1DH2ofaRxIKeP"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20934.003
X-TM-AS-Result: No--8.587-7.0-31-1
X-imss-scan-details: No--8.587-7.0-31-1
Message-ID: <68d0a62f-eab6-4eb9-8c9c-89970749fe47@BY2FFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(189002)(377424004)(199003)(21056001)(20776003)(99396002)(81542001)(70736001)(79102001)(80022001)(74316001)(44976005)(6806004)(77982001)(71186001)(65956001)(83322001)(19580395003)(54356999)(64706001)(50986999)(568964001)(83506001)(102836001)(74502001)(74662001)(85852003)(83072002)(92566001)(87936001)(86362001)(575784001)(92726001)(31696002)(84326002)(81342001)(512874002)(1496007)(229853001)(31966008)(90102001)(106466001)(107046002)(110136001)(85306004)(76482001)(104016003)(95666004)(4396001)(46102001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB006;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pQ43GaAP8wnQJglTV84u1DH2ofaRxIKeP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these bug fixes to your tree.

Thanks,
Michal

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608e=
bd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.17-rc5

for you to fetch changes up to 9fc4b7e241a7b6da46c5da0ee6f85d99e91dd024:

  microblaze: Fix number of syscalls (2014-09-09 13:14:47 +0200)

----------------------------------------------------------------
Microblaze patches for 3.17-rc5

- Fix Kconfig menu structure
- Fix number of syscalls
- Fix compilation warnings from allmodconfig

----------------------------------------------------------------
Chen Gang (2):
      arch/microblaze/include/asm/entry.h: Include "linux/linkage.h" to a=
void compiling issue
      arch/microblaze/include/asm/uaccess.h: Use pr_devel() instead of pr=
_debug()

Michal Simek (3):
      microblaze: Add mm/Kconfig to advance menu
      microblaze: Rename Advance setup to Kernel features
      microblaze: Fix number of syscalls

 arch/microblaze/Kconfig               | 6 +++---
 arch/microblaze/include/asm/entry.h   | 1 +
 arch/microblaze/include/asm/uaccess.h | 4 ++--
 arch/microblaze/include/asm/unistd.h  | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)


--pQ43GaAP8wnQJglTV84u1DH2ofaRxIKeP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQO4sMACgkQykllyylKDCH56wCdGQNfDAaaBPINnK6dZGOx32S3
GgYAn3dIQWAcI1t0hShI4J4+aBWqhb6Y
=aX1f
-----END PGP SIGNATURE-----

--pQ43GaAP8wnQJglTV84u1DH2ofaRxIKeP--
