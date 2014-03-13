Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaCMAIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:08:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34216 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaCMAH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:07:59 -0400
Date: Thu, 13 Mar 2014 00:07:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140313000750.52aa2ca0941e17cf18d87a19@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Mar_2014_00_07_50_+0000_yNXuxg3G_0Z6AU23"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the driver-core tree with the tip tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Mar_2014_00_07_50_+0000_yNXuxg3G_0Z6AU23
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in arch/x86=
/Kconfig between commit b4df597ae51f ("audit: Add CONFIG_HAVE_ARCH_AUDITSYS=
CALL") from the tip tree and commit 2b9c1f03278 ("x86: align x86 arch with =
generic CPU modalias handling") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc arch/x86/Kconfig
index 81f8485bb6b7,7fab7e0b1a72..000000000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -127,7 -127,7 +127,8 @@@ config X8
        select HAVE_DEBUG_STACKOVERFLOW
        select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
        select HAVE_CC_STACKPROTECTOR
 +      select HAVE_ARCH_AUDITSYSCALL
+       select GENERIC_CPU_AUTOPROBE
 =20
  config INSTRUCTION_DECODER
        def_bool y

--Signature=_Thu__13_Mar_2014_00_07_50_+0000_yNXuxg3G_0Z6AU23
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIPbWAAoJELSic+t+oim9OBgP/iDPq1i0qjHZosCqzd12BQq1
ygcbgCty2LtVTVTjiUCQWyr2X3gg7uda+viZJbkKdhNzUb5QBRRpxr8HjMC/Xlqj
S+s4v7YLeAYRrBM7WLBa0QY8Znsc8yjm12BfUHreHC2gtvBOyb1qydAt8bcAF6G3
d8mnmlsOCNE2iFTp1gGtN+kNl5T5TvcpDn9rMuOVrakY0lzEmiD5AzMZCDU1MAO6
A+3MFC4d0IANOQT6a3ee3BanEeOWQ0It7ti9qN/cVdCvkGTZkUaokqYNdWQq2HER
9VuN9Db4YqcGtmtKK8cquhlJJrzgQfCb0eJ5dGpIOKSlT7s1vYFscmSSZtdcOzbn
G4S41FKJZwUCbN3wkzNlzIDx+qpfRZjYH9bkhGI1Frjzm97FOeE4vZ/TZvaF5uoJ
oce0G61OWD6kJbhLSoqANotc17z1B36wzyMqgcWNpV4iaCOk/5YV8awKe3ycASQt
GRjr0GgStdeJK4/5IEOAkd2ejxJxNbYb3Y/tIcBoLO8wmaFEApKJMS7VqIS0Fbmf
TsWrlBRjmFfxUA8pkxwdQXrlmUWO/9PnFkF9uexRaIdp8N4qHPZqoR4zTHw0WALL
DU8S8trw8ZsmztWN4+k9L5kvBQIo26WNFCD8f6dFwQzTuEiE30MqQ7+nx5WkNOVW
TSFwW648tCtMzhBzw7o6
=gNCC
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Mar_2014_00_07_50_+0000_yNXuxg3G_0Z6AU23--
