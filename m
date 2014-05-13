Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaEMTjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:39:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24273 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaEMTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:39:08 -0400
Date: Tue, 13 May 2014 15:39:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (ibft) stable/for-linus-3.15-rc5-tag
Message-ID: <20140513193903.GA31383@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Linus,

Please git pull the following tag at your leisure:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git sta=
ble/for-linus-3.15-rc5-tag
=20
which has an regression introduced way back in v3.2. The Broadcom
NICs offer an iBFT feature - but they use a non-standard identifier
and that got lost in v3.2. This patch puts it back in.

drivers/firmware/iscsi_ibft.c | 1 +
 1 file changed, 1 insertion(+)

Vikas Chaudhary (1):
      iscsi_ibft: Fix finding Broadcom specific ibft sign


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTcnTTAAoJEFjIrFwIi8fJ3OgIAId3Z8xB4puhXW0Oz21QXiSb
+dtB4lb+nIqnPTNSyxQDrTwGkRlHoRs2XiZtREr4nZRnSwz81Cbt+Rp/g7LsTZO+
dilxv+3iiGgkDFiQLAjOGQeRAUODXmVXP3V7RlsL8UV3oRn6UnGja52mzBlUZ8yl
ILojvY5jrIGslVy9nLI4hnxFaJIYBA/SAytut8o6pF25QhG/OTEuVTAr20AQoQDq
SSryWD2znV8NM6E849S8S+fW5b7LvmmIK7RZR1f3NoUhsM/MWsUFSk5ezgU7Chxg
ddbUgZZrZ53e2jL16KSwE6yrjof5d1yrKs2ZdEE5sQhCgHLMLAELILuXDV7pbpM=
=62ow
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
