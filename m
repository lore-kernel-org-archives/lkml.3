Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435AbaKOAyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:54:53 -0500
Received: from ring0.de ([5.45.105.125]:56044 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbaKOAyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:54:51 -0500
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: infradead.org]
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 15 Nov 2014 01:54:47 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [GIT PULL] Power Supply changes for 3.18-rc
Message-ID: <20141115005447.GA655@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 7881c64716f3a7d60b325ed0ad4d15f49b474a43:

  power: ab8500_fg: Fix build warning (2014-10-05 02:10:20 +0200)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.18-rc

for you to fetch changes up to cdaf3e15385d3232b52287e50692506f8fd01a09:

  power: charger-manager: Fix accessing invalidated power supply after charger unbind (2014-10-28 03:30:21 +0100)

----------------------------------------------------------------
power supply and reset changes for the v3.18-rc

 - misc. charger-manager fixes
 - year 2038 fix in ab8500_fg
 - fix error handling of bq2415x_charger

----------------------------------------------------------------
Ebru Akagunduz (1):
      power: ab8500_fg.c: use 64-bit time types

Krzysztof Kozlowski (6):
      power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle
      power: bq2415x_charger: Fix memory leak on DTS parsing error
      power_supply: Add no_thermal property to prevent recursive get_temp calls
      power: charger-manager: Avoid recursive thermal get_temp call
      power: charger-manager: Fix accessing invalidated power supply after fuel gauge unbind
      power: charger-manager: Fix accessing invalidated power supply after charger unbind

 drivers/power/ab8500_fg.c             |  17 ++++++-------
 drivers/power/bq2415x_charger.c       |  23 +++++++++++-------
 drivers/power/charger-manager.c       | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 drivers/power/power_supply_core.c     |   3 +++
 include/linux/power/charger-manager.h |   3 ---
 include/linux/power_supply.h          |   6 +++++
 6 files changed, 144 insertions(+), 72 deletions(-)

-- Sebastian

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZqRXAAoJENju1/PIO/qahEgP/jtQAlZ9tsB0ZuviVixEB16T
Knbmo2qqQ8SYVAZFRjeg9cNqy1trI/CtQX15z6NOOepFYuTeZI4vRo0/nj5fN0+S
ZYoyCIEhsODIzg8OZERkoRc4hF87x95yQU2BMwUCUeVNdjKvncAu6QBxd5NW/5Gz
B/ztNOXJIrPQnOVxCv39h9D91DNsRgbCGcpu6IL1Dmb6MGVYJy94AQyxNUximCvc
Q0N6ojfhgSMDQd3RywYmqmhkIjRJxxgXUZwQ8wRYg/vRX4zCn0kqEQnixSPNS7j1
goW9VXAYp+ccHDzq6uOv59f9CsZKp7oTT1nflx2oKcoQ7BaLs9K0dZEv924O/E21
qoamFHQOheGkJuxfQGbaYqeEDgvvK0kFYVCVsdTSMRTJwEX9+Md6nZNt6SHX5vVM
vx6RJHDzjBFvguFzTCbxktEZX+sUkYac3zUAF8yxquUWGGM+gjEw5ZbJ/FHNKea3
E5meIVH5tekvNRuHE+bP+4NfxhPz1kyu5rmsgWra6go5if0Dyk6dXJHQqdFoKPCz
fp/b+SzKaUPq2kUu3ICfpGan2YUus3dZb/akHbMeBI+TsAmaIhEyOD5BPZD37y9f
Jzq+rtxIOCdDVz2ivsD5XRzu33Fbv5edgHGivUibyG3qzKLnSjsrB3b14KjGic7G
Acmri7hFctb2X2F2QvHC
=UBIh
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
