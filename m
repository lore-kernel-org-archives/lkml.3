Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaDNAXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 20:23:37 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:36793 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaDNAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 20:23:34 -0400
Date: Sun, 13 Apr 2014 19:23:30 -0500
From: Greg Donald <gdonald@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Docs: Fix elisp code so tabbing more than once works
Message-ID: <20140414002330.GA5473@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=0x42C14D83&op=vindex
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The example elisp code breaks tabbing more than once on the same line. Alig=
ning
equal signs in a struct becomes problematic. Fix it.

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 Documentation/CodingStyle | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7fe0546..287d22f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -512,6 +512,8 @@ values.  To do the latter, you can stick the following =
in your .emacs file:
                 (setq indent-tabs-mode t)
                 (c-set-style "linux-tabs-only")))))
=20
+(global-set-key (kbd "TAB") 'self-insert-command)
+
 This will make emacs go better with the kernel coding style for C
 files below ~/src/linux-trees.
=20
--=20
1.8.3.2


--=20
Greg Donald

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJTSyqCAAoJEHjl9MlCwU2DN2oIAPCJ+v6Zh/WM+UbzKPghNDz2
5fiwdoayKtIh2ICjC1neJmErGLsJ9IvKSlj7WkFNZCuE6sz+XV53GZmVjC/vQLFB
jyzpn41Kvnisepm6+oypMsRqnNx5j4XlMNMAfljc5mz2JUZAurN1OWt6/iHz4nWq
MVBjKsG5kTYpwW0B3MFufCgPQKc8kk0Dj7ELd8hoR2ME4jcgGGapKBwoN0YpgR/Q
93hRFH0IQteSpLma7yTvUrCjuusISLDmONiacVRyS2HLU4HiAXvwU4IOkB21/FRG
+Hl8NREfAn+OfQOoCS8IVDorW51kiI5zF0KYjuatmUuY2R+JmhMEaL8bqANhPjo=
=nkUR
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
