Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3E0Avq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 20:51:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39776 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3E0Avo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 20:51:44 -0400
Date: Mon, 27 May 2013 10:51:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Helge Deller <deller@gmx.de>, Parisc List <linux-parisc@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the parisc-hd tree with Linus' tree
Message-Id: <20130527105135.cac99b7d9930fbb2f03cc9e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_May_2013_10_51_35_+1000_W7FyexJiBct4XBBG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_May_2013_10_51_35_+1000_W7FyexJiBct4XBBG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the parisc-hd tree got conflicts in
arch/parisc/include/asm/processor.h and arch/parisc/kernel/irq.c between
commit d96b51ec1465 ("parisc: fix irq stack on UP and SMP") from Linus'
tree and commit 1c92ce8487f6 ("parisc: use arch_spinlock_t instead of
raw_spinlock_t in irqstacks") from the parisc-hd tree.

I just used the version of both files from Linus' tree and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_May_2013_10_51_35_+1000_W7FyexJiBct4XBBG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRoq4bAAoJEECxmPOUX5FELG4P/RukX9IpW+tSj9jK3PX4OAne
9brkGUKGPG0Rw7MjfTdbLYF0vAWc7T/ir4Mk5coG0SCZ2g81FT005mhcV9i1ytyq
CzxLfaL81VAZ3JbwDxc/+Oir4LmnUFhbBFPog9WJdzEz3hLnY7irphyWWJEvVRqi
gSk20gk2t3NqVYel88dmdxyXbqI6wWUZcK9IjY7S5qRbLaTaQl+zKXChF0stX3z3
V1LNnEqCKjWxUWXKf/1KlOWzAv+LgVkynIr5vCNrTAv6Lr+bU1zD5OssCeNAPYy0
ph++rFlrd5O2IYb/BSiB/ad8QWVzPKdsQtmwgMMsTz/hYKS7ksWDA1bItAktk1vO
5EihbxRW9DLDffj8TgCYE0sOF4IPZPIhhWkRnE+y3T6AAi2MJiUKkMlpVWWoTKXH
KYlIUYI7BLdnfOz8UNE6SAe/2CLtvHePTI0khEbXAg8/RmW3AJdigpKsqKRS3w13
LlnUvbZkAWweueriWg+zxXYX3cm24Fk6sRbn21HZ+IuOQzlk22npbj24ASqZOzuT
BDxCTa0GQN5t8Pk+sJSwVfMkS06T6yvuS0e9NTQilGhn7M+JBGAoScWR4RD5QY4e
1XMS6t619D8ASJ+sdSbLyEF84+dNyJMBTiPd8ssgVHSiVPxI2ma+ExIr0GFxI6t1
DaGs1c/atoNgLAtW2gnB
=hYgt
-----END PGP SIGNATURE-----

--Signature=_Mon__27_May_2013_10_51_35_+1000_W7FyexJiBct4XBBG--
