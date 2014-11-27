Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaK0IFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:05:18 -0500
Received: from ozlabs.org ([103.22.144.67]:47549 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaK0IFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:05:16 -0500
Date: Thu, 27 Nov 2014 19:05:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boaz Harrosh <boaz@plexistor.com>,
        Benjamin Romer <benjamin.romer@unisys.com>
Subject: linux-next: manual merge of the staging tree with the kbuild tree
Message-ID: <20141127190508.3305dfe8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/z7r4_AxhkWLvrIgTw7_.OhN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z7r4_AxhkWLvrIgTw7_.OhN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict
in .gitignore between commit dfe0487249e5 (".gitignore: Add Kdevelop4
project files") from the kbuild tree and commit 75185f57f110 ("staging:
unisys: fix CamelCase macro names in controlframework.h") from the
staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc .gitignore
index ce57b79670a5,6bfac06d79ca..000000000000
--- a/.gitignore
+++ b/.gitignore
@@@ -97,5 -97,6 +97,9 @@@ x509.genke
  # Kconfig presets
  all.config
 =20
 +# Kdevelop4
 +*.kdev4
++
+ #eclipse files
+ .project
+ .cproject

--Sig_/z7r4_AxhkWLvrIgTw7_.OhN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdts5AAoJEMDTa8Ir7ZwVSEIP/178dha/InCz0KX52fmFiMHD
6knpogEfDJM6myTKwU5XY14uoeid3Hl14AMRGFeiGyKVxr9Ty0es0qAXrrrNDVEh
lTn9HIQ5tSLw8SAvfOU2Xk2CtQFDjD/3SUTd9AfAPX9P0nm/2Z1mb+/U2ja84sio
mGdKe1xBcL0wgvpXHb3N8ZJ8rANimiBVtEdjr9DWv9VRUZBZGylo2EfiLYUN4jas
LcoXZiRaMP/4ZAseMPOlxJed9mBw8CynXgnKcXKN55WXODruUNXWxAp3KNW6FvOW
KOT9bxr86JK7LBozmsZR81vhoxSNQMZwLiqkxot8s3iJPO0XrDjF9PZGEQnZHYba
GSU3FgVZ3JJ3yz9hietWkV4BT4YxrLFsflgscCHzKMVFcuvqujz//11ntQDk8ApN
qEXLTLC9pXKH+WUk0BKpamecVaip8lDu8Y87Q3vwIyurRE46/w6bYFNyo+JsNCZD
Ib5Qq4dlwHQ2Pe7Uf/jTLCjA7xHpMSso0NSxYS//ts1Zfut34+MO48U4VdM3Q7kB
zE7WfdGAEGfu3dQ6EHo3hpVSJUHXxhoP/wO6LTRuMwNhCy4saf5gFJnTkxAHMqiE
Ywhk9tsj4jyzj6cAi+lFpiPpoRvdW4yT6Ldf8CqAcgcfYFaeAGrl1T/CKQ3UPZUj
+kQWbIydnGYqXDr0Dip9
=BA1/
-----END PGP SIGNATURE-----

--Sig_/z7r4_AxhkWLvrIgTw7_.OhN--
