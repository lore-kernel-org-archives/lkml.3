Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaHVXiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:38:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51299 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbaHVXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:38:53 -0400
Message-ID: <1408750718.4672.30.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH RESEND] firmware: Update information in linux.git about
 adding firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-firmware@kernel.org, Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 22 Aug 2014 16:38:38 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oK1XEgdmXu4N/eRb5zzI"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 131.252.184.246
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oK1XEgdmXu4N/eRb5zzI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kyle McMartin recently joined the linux-firmware maintainers, and we now
have an alias <linux-firmware@kernel.org> which reaches all of us.
Include that instead of the individual addresses.

Add some further recommendations that were already included in the
README in linux-firmware.git added by Xose Vazquez Perez
<xose.vazquez@gmail.com>.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/README.AddingFirmware | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/firmware/README.AddingFirmware b/firmware/README.AddingFirmwar=
e
index ea78c3a..bcb5f46 100644
--- a/firmware/README.AddingFirmware
+++ b/firmware/README.AddingFirmware
@@ -21,15 +21,25 @@ been permitted to redistribute under separate cover.
=20
 To submit firmware to that repository, please send either a git binary
 diff or preferably a git pull request to:
-      David Woodhouse <dwmw2@infradead.org>
-      Ben Hutchings <ben@decadent.org.uk>
+      linux-firmware@kernel.org
+and also cc: to related mailing lists.
=20
 Your commit should include an update to the WHENCE file clearly
 identifying the licence under which the firmware is available, and
 that it is redistributable. If the licence is long and involved, it's
 permitted to include it in a separate file and refer to it from the
 WHENCE file.
+And if it were possible, a changelog of the firmware itself.
=20
 Ideally, your commit should contain a Signed-Off-By: from someone
 authoritative on the licensing of the firmware in question (i.e. from
 within the company that owns the code).
+
+
+WARNING:
+=3D=3D=3D=3D=3D=3D=3D
+
+Don't send any "CONFIDENTIALITY STATEMENT" in your e-mail, patch or
+request. Otherwise your firmware _will never be accepted_.
+
+Maintainers are really busy, so don't expect a prompt reply.


--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-oK1XEgdmXu4N/eRb5zzI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/fUg+e/yOyVhhEJAQq7VxAAhD+LHZ1IQHfT67+/O5xfyAhFDjyV8Cl2
NihCojcdQJK+tzt6IT3k87rSgHyD/nORC+ZQf820LnpHFUsC7feXzgv78le8FHOZ
UTctVaHJxzQ7/HyVpwHXz+x8U0iG8nYf6W4j1B+2vKEqWshLSZgjPDryugdweNqw
QNpZI2LPL3JjFVcBvnTN/7YgpBXZC7CuXinWLRiz7BESjrYUWoEUzgxsWWeDJukr
0mhfnGl0idrYUjJwYVmdxJgXnWsrLQ+8kKv8DBOSnonhjoW9ajxQ//flzK5vOLLt
8lp9Wg6YwExgKteDMB7yVazzesAHq7G4iS49KkLcVEig7aF/62NtKF1+iyCAZatk
pJhUF58x0GG54u6ySOOp26MtLy/etu26WZRE5jlyLFM8LpCy2/VyfHpzu3ZI75Ka
5QT5FbPYlcX7OYVpCG08Ns1/DUFV+seaPcdEryNySdcgE+ydOpR6zV6RtVztYjuu
QfsM8cEB4TjQuSEMaR04b+dEMaYxSg6W35rq4Ts7372lB/KvDOgeTaCQG7/N/5/g
8cdsI1HVVggpbbkYljKqJo0j6w6rX8D/vpr84TzOZoZdQZIeF0HcmIOOrADxQ11a
kIjMreO5BZ1lcKDfwXjXVqYG1qtUJ2rgnkBZdBh5AmGutuz30DESsPZkvL1KeSqX
zil8y9OhWjs=
=DdRm
-----END PGP SIGNATURE-----

--=-oK1XEgdmXu4N/eRb5zzI--
