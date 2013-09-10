Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3IJVCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:02:10 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40455 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3IJVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:02:08 -0400
Date: Tue, 10 Sep 2013 14:02:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.12-rc1
Message-ID: <20130910210205.GA24994@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.12-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit e5c832d5558826cc6e9a24746cfdec8e7780063a:

  vfs: fix dentry RCU to refcounting possibly sleeping dput() (2013-09-08 18:13:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 8876dd78d9f0cd317d55dc19e5cd17194af15b52:

  hwmon: (ina2xx) Remove casting the return value which is a void pointer (2013-09-10 06:28:31 -0700)

----------------------------------------------------------------
Minor cleanup in ina2xx and hwmon-vid drivers; no functional changes

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (hwmon-vid) Add __maybe_unused attribute to dummy variable

Jingoo Han (1):
      hwmon: (ina2xx) Remove casting the return value which is a void pointer

 drivers/hwmon/hwmon-vid.c |    2 +-
 drivers/hwmon/ina2xx.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSL4jNAAoJEMsfJm/On5mBrEEQAJCOqm6n1lWHJ+iU/vJ2gR1i
EgIO7Ogz9t8yITLq3kVyvFpH/nnoZnx7dL+N14xhLOfk6N4ypS1SEBVb39zDoYXC
duoq2jWn0pG0PGFsLkSoFBLRTZO4w0Axd2J9P2urpWRquxdROtrJdDwUXJ4s50TR
2ydixXGdHgKjjY9l4X2RdVElbGpYfJ0LETa3h2dsURR9NFpGlM2uyZVXmgaIqx/c
8FN2lC6PEZOoyMkTIqu7OqGQvnDx/5vaYaREPRtzAcV8/eDQctzTDl9/gnAnB26d
oOuatm8qLCjCuE8E2B4Ny79WNKTi7w+saqECQ2qyBPqFecej+lSBstH5+k7mKNG3
XKPFF3bJ7vlGfxpzU+LFpqJ1SlkV62Wo5PdiJdYkthTIWQtNMZVQEvbM/Ll0rJl/
kxjbbtumpYZAh7smb5AUoQ11jG2Mz59FPz0wvUdbTw1yCr7zq4rawzCiNFYPyrhh
tGFZLo1jvjBLweS3QuEexHU5EFRdTQzFjS26vI2EBxTfXyEC74SkOWcXlWWlA7On
yHnqv+WfDl4Y8+MnrI8GlhW/LcWJjHmgR3hDXWp61Oc38O//JkU39n3MKfoh7C2u
ojOfUp9cfYPrmb4R1kYZtNP8UkK0VN1bzNO4CU2enmWZuQqsRk07A/y5EPmzoTNk
rod+Z+qkSlG/FBWq55FH
=AdJ9
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
