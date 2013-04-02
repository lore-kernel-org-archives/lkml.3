Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab3DBWDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:03:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab3DBWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:03:12 -0400
Date: Tue, 2 Apr 2013 23:02:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.9
Message-ID: <20130402220258.GN23065@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8zN2sh9fO5jmbe4"
Content-Disposition: inline
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8zN2sh9fO5jmbe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.9-rc4

for you to fetch changes up to af8ee69df3b5cf4649d65efa3aa359c73c48402a:

  Merge remote-tracking branch 'regmap/fix/async' into tmp (2013-03-31 23:27:38 +0100)

----------------------------------------------------------------

regmap: Fixes for v3.9

A small collection of fixes.  The most important ones are those from
Stephen and Lars-Peter both of which fix cache issues that have been
lurking for a while but not manifesting noticably enough for anyone to
report them.

----------------------------------------------------------------
Dimitris Papastamos (1):
      regmap: Initialize `map->debugfs' before regcache

Lars-Peter Clausen (1):
      regmap: cache Fix regcache-rbtree sync

Mark Brown (4):
      regmap: async: Add missing return
      Merge remote-tracking branch 'regmap/fix/cache' into tmp
      Merge remote-tracking branch 'regmap/fix/core' into tmp
      Merge remote-tracking branch 'regmap/fix/async' into tmp

Stephen Warren (1):
      regmap: don't corrupt work buffer in _regmap_raw_write()

 drivers/base/regmap/regcache-rbtree.c |    2 +-
 drivers/base/regmap/regmap.c          |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

--K8zN2sh9fO5jmbe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW1WEAAoJELSic+t+oim97V8P/2SB6o65tv8XwMuOXFRrWmgQ
zLo6+5vwZVZ7kdyEoJJRJKXWVaZmRohnF3f33dZkgMNrjNSfkxgISJTr4/+J44eK
E522oQuBucDkMtUNm40PmkrXe2WzkqOxznG/dxpG8rRPYG7olqDTwkrAK98DmRqg
hZNLXHMouaI9J3RQ1w85P6R6UJCmxskVdjeKE+jT/Yv4bo/zSLUHkSiio3L46uU4
I/4gpepejm6lV7tIHBcgEyaX3SzcK1BdGdNBHDAeaEu1cyz5pgRbDkM4zOtf44a2
e1ZUO/rIdn3zV/5uLmUA9YYWMKTqxLrWqZXGKu4jaqhthi3NLuaDxj/D6BMLiiEy
koJIl4A1VHjsmIgxUbkeAFw/QDoI4qlY/V8/3aOwIFHxqNtWecE/i6oiamIPOMbf
EiMIGfzb1qLA1lk/o9jDuKsWcUstUwcC3J0BQGGdBivn5mQLs103y7Ynbun87VZl
km5baPRn9CTZqVsUFztmL4jtt8hV35hsL3pQbxrxpjL8GbLXt07b1/IPNd3gmDaZ
EKJoa0n80xalJsYTO+PUpKc92eKRl32KvfflRPlcx2cm5Eso3MDlm+YAfPUPN4v2
WDHj3Q16GMuKT9y3LYvXtiUI2tug/tDWOtlUYjBr3EqYUwUnOVbLmCnAEBHKo0Ge
cXeFHUnNaN4/8Wno1JC+
=gric
-----END PGP SIGNATURE-----

--K8zN2sh9fO5jmbe4--
