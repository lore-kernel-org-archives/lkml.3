Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaAYVYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:24:31 -0500
Received: from mout.web.de ([212.227.15.3]:62155 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaAYVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:24:29 -0500
Message-ID: <52E42B86.1020701@web.de>
Date: Sat, 25 Jan 2014 22:24:22 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] intel_idle: Add CPU model 54 (Atom N2000 series)
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Kd48UGb7P6MSGGEd0xUKGEtEFSqmMcGfP"
X-Provags-ID: V03:K0:896LtonCTof/PksRSER/orsOn9L9A2+eUnzL8NgbWpY6WicX2QO
 PWdH3k9bkGgT28V5RoqpYv1+0lnyg1/J5aXzCvFC01UtZ6UspRU8iXvOfxVpicb6d+pdYPs
 yJjPZL/K03DvqPsv6P7A4sCwkCkC0wSRTyg8rrk3Mxphpet/qZDS5E6hE2iuFBJN4OQTQw1
 /Dq6xpwqDK08GM76wKAsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Kd48UGb7P6MSGGEd0xUKGEtEFSqmMcGfP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

Add CPU ID for Atom N2600/N2800 processors. Datasheets indicate support
for this, detailed information about potential quirks or limitations are
missing, though. So we just reuse the definition for the previous ATOM
series. Tests on N2800 systems showed that this addition is fine an can
reduce power consumption by about 0.25 W (personally confirmed on Intel
DN2800MT).

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/idle/intel_idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 797ed29..6467fc9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -503,6 +503,7 @@ static const struct x86_cpu_id intel_idle_ids[] =3D {=

 	ICPU(0x2f, idle_cpu_nehalem),
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
+	ICPU(0x36, idle_cpu_atom),
 	ICPU(0x3a, idle_cpu_ivb),
 	ICPU(0x3e, idle_cpu_ivb),
 	ICPU(0x3c, idle_cpu_hsw),



--Kd48UGb7P6MSGGEd0xUKGEtEFSqmMcGfP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLkK4kACgkQitSsb3rl5xS3pwCeLGH/PDLKEWhphdkp6E3BKacj
YLwAn0e0hsVQ3tPyiA1Lv7bidQCIQyB8
=bgHv
-----END PGP SIGNATURE-----

--Kd48UGb7P6MSGGEd0xUKGEtEFSqmMcGfP--
