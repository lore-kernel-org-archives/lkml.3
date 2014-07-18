Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbaGRFXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:23:19 -0400
Received: from ozlabs.org ([103.22.144.67]:34300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbaGRFXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:23:18 -0400
Date: Fri, 18 Jul 2014 15:23:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: linux-next: manual merge of the irqchip tree with the trivial tree
Message-ID: <20140718152304.3daf648a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yc1Ki.IPPz2vg_71VD66BN4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yc1Ki.IPPz2vg_71VD66BN4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the irqchip tree got a conflict in
drivers/irqchip/irq-gic.c between commit d31e373d0778 ("irq-gic: remove
file name from heading comment") from the trivial tree and commit
fe7ac63fe539 ("irqchip: gic: Restructuring ARM GIC code") from the
irqchip tree.

I fixed it up (I just removed the file name from the comment) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yc1Ki.IPPz2vg_71VD66BN4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyK9AAAoJEMDTa8Ir7ZwVRVUP/jsmFaWVgiYu9rJnVPyOL0Vg
MnFZXAJ8dZxuGiS2F34hbkk/gv5/IOki5v86EVnG6K95WiwA6Hp9cjtFMwRcy/AS
dNWTF2RzUU7Rv6MpHFtJrQvX8N8KlxjCHJdfll50fcDLDp39Riw8tOC+KvVIK0lL
uy3rkJ1Z3pPr8aZ6yDBGPInCUmD96uScVEGhcKKNLa/3WrGf6CQcEf5nfntNECKv
6mUQaZgl1jKF53AqovKQY2E+hdcRq4fviEEIFqbEcFd+LN+5/cXeMpCRnFawGHAn
ocTooQp6mCu+4dsvmlPQienlE3LLSeC0KV5bww9gTf7TU4AYQkoIhYbCJ/ua7y1n
ftgNjYZPvFCJHfz+qUFOpmIHLNDT6+SRV/RabRdpG02BfJ2TeyGmkzzWpiqq6WRr
NU6megSNNxMbvmZTwW+C2f7m10GlqjCbK+ulsUtlIRkOcC8ei6vJT26l0HVdS6i6
/ZJ1Y8Cb5NB310c00pBOAn4ARcoYx9ClGoLHHZqh8ATX35q1XaSXqjOaRhTHZUSR
SCPTRGcIh2Q19kJ71eEIPIwlKwLyDbAUvgykWL4IJyu2pl4at6T/4q4phiXLcYqY
YDA6axQ1L8vTrkkKaB5+ZVz510aEfzoPiWhGqKRlZm9ckvNkwRIXEez2CwO3xULa
oyOLkbjvUzsEBUeSSpFg
=akol
-----END PGP SIGNATURE-----

--Sig_/yc1Ki.IPPz2vg_71VD66BN4--
