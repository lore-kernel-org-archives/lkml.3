Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaKMBsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:48:06 -0500
Received: from ozlabs.org ([103.22.144.67]:59321 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaKMBsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:48:04 -0500
Date: Thu, 13 Nov 2014 12:47:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-ID: <20141113124756.6d5d8e96@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/C2rMn0WO_ZPOVhFya5Rdukp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C2rMn0WO_ZPOVhFya5Rdukp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/viperboard.c between commit b6684228726c ("mfd: viperboard:
Fix platform-device id collision") from Linus' tree and commit
5e65ea8c48e6 ("mfd: Use mfd_add_hotplug_devices() helper") from the mfd
tree.

I fixed it up (I just used the version from the mfd tree) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/C2rMn0WO_ZPOVhFya5Rdukp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUZA3RAAoJEMDTa8Ir7ZwVlo0P/2fq+mBDHse3DIfF+TmiwZpe
Te/21BEE1f73dQ7kEX1FxzXsGta0XiOUviv++Gns8Ps+gUtc8Ba5rtJ//Ao8JAOf
w0r9pcnbhdMM9W5+2l6xYuTG2DQly9t1tWV4xjxQaVfUgEMdzbcUs90sIDWv8LMl
JZzaojqKNriTTLZexEGSYpFUs+R4lmp2UbuOOSqZIeppZouljez9rFMnE1Jrapqm
SIpnzAMkGoWNVLU6DQ/BNMQpsvOFdpEZ23UwqMDjm1XhRgEvzIvunZ/UNWTT8hI1
DxNPuhEQalleyjEWhK4JzF1f18M2eX7eYCgMWa+NwGCx/EEVg43hAazDWqxaAGm7
CnjiQIy0RQhCUS7t14+RP9SeTFT4f5tye5Y7cu5nWuWkSTgyc4YXYO3pNMX+g9w8
KXa9nGWNLOPi1NroM09NO5qkUeDECexoEyfMSEaLi4HlSeEjPlinYR9D4Bz0avTx
LYf+dfV3LgMoSls9sXHMMkHUz0hI1m8Qm6cuDevJBCbbsbo2helzKVs1n/rXblSa
WTmaVY4Xv7v2o/AGRr+L7eQ+S0GkoA0QoWFTPgKQ0ehL5Sl7U+MhYSQ3tCnCiZ/T
amj8Lff2EQkFHy9DrKPW1dxg5JTj9Xddkgp68/ozUQ1BRx8M72czeXHzGFgkj1OO
2xXYLoR3A3le9DwXsBH5
=UPbH
-----END PGP SIGNATURE-----

--Sig_/C2rMn0WO_ZPOVhFya5Rdukp--
