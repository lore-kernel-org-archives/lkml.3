Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3LRGji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:39:38 -0500
Received: from ozlabs.org ([203.10.76.45]:60172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3LRGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:39:37 -0500
Date: Wed, 18 Dec 2013 17:39:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: linux-next: build warning after merge of the target-updates tree
Message-Id: <20131218173930.56f758971ca1939cbc3e67ec@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_17_39_30_+1100_VXSR.XynMKLT07Re"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_17_39_30_+1100_VXSR.XynMKLT07Re
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/target/target_core_alua.c: In function 'core_alua_state_lba_depende=
nt':
drivers/target/target_core_alua.c:473:6: warning: suggest parentheses aroun=
d operand of '!' or change '&' to '&&' or '!' to '~' [-Wparentheses]
  if (!cmd->se_cmd_flags & SCF_SCSI_DATA_CDB)
      ^

Introduced by commit 923aacab87ba ("target_core_alua: Referrals
infrastructure").
--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__18_Dec_2013_17_39_30_+1100_VXSR.XynMKLT07Re
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsUMmAAoJEMDTa8Ir7ZwV3ycP/0L+RcFpmpTnsK0xpwhMXPwp
1YuP2hl7FgXSnh4M55usZJjla9tJG23qncUA3QTkBV8oWPGd0BNlDPFXmbN0wPdg
Bji4mz5+f8R5FYVouimlcmHEDGDhv9NxoGuaY01gOr0BgHlnZYBuLHa4MsC8EDkr
4Oxwjs2Fh/Op07nswlw4r+6IwH+h5TEP2Q+eykljulw5P3+uUDDigJyfJC7A67/U
/2O9n9G4668qJnKqm3CPNMMYvmBJVt3BVjMYNwWEg0mm3hT/rqCH27wQRN65xMga
aiS1j3nj0RgTYYW8RWWGp8WYojEs5fI6TyCl0sydI7At1u/lrG+9UZiyyxACpHwe
Ffwl5XtuYzuA11K81Wtakm67957RUqI6kcSIrwviTqqso1NzZhpSxfvYpksJWydQ
Yg5HNxlCBxJEfELTKk/YA7lQ+4HF07IYFev4ielUCKKEAZGJGvlqj0G++xqDlWAb
cC76jDYDQOVYe58ppnQeW5FENdGLk+Ijf2JMo+33Qsc96uHmpnjP6WtA9CTlunsp
6SCF9nAODAo2Ke1CpNjfeqkAeJSTI7fUgX0PknfckFQXKm7wrYsXIFHIDqjl5tCo
B9PJia8QC6E0SR/EtUSon5nq1lRSkPVWl6OLre5yzmzXHHMwMz03lW+aC3PKsCZv
e+LEEONflTIhD6CpbBu2
=PB2h
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_17_39_30_+1100_VXSR.XynMKLT07Re--
