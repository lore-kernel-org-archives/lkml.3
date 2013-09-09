Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3IIPlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:41:50 -0400
Received: from multi.imgtec.com ([194.200.65.239]:58260 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3IIPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:41:48 -0400
Message-ID: <522DEC11.106@imgtec.com>
Date: Mon, 9 Sep 2013 16:41:05 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-metag <linux-metag@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] metag architecture changes for v3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="xaVKES4ML4kOhJbBMMU2BjtbCXlJ4J3bB"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_09_16_41_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xaVKES4ML4kOhJbBMMU2BjtbCXlJ4J3bB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull a few arch/metag changes for v3.12.

Thanks
James

---
The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a=
4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.12

for you to fetch changes up to b6ef9161e43ad58c3824bd76dc87716276f0cd70:

  irq-imgpdc: add ImgTec PDC irqchip driver (2013-08-21 14:17:56 +0100)

----------------------------------------------------------------
Metag architecture changes for v3.12

- Device tree updates for TZ1090 GPIO drivers merged via GPIO tree.
- Add driver for ImgTec PDC irqchip as found in TZ1090 SoC.
- Add linux-metag mailing list to MAINTAINERS file.

----------------------------------------------------------------
James Hogan (5):
      metag: tz1090: select and instantiate irq-imgpdc
      metag: tz1090: select and instantiate gpio-tz1090
      metag: tz1090: instantiate gpio-tz1090-pdc
      MAINTAINERS: add linux-metag mailing list
      irq-imgpdc: add ImgTec PDC irqchip driver

 .../devicetree/bindings/metag/pdc-intc.txt         | 105 +++++
 MAINTAINERS                                        |   1 +
 arch/metag/Kconfig.soc                             |   2 +
 arch/metag/boot/dts/tz1090.dtsi                    |  67 +++
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-imgpdc.c                       | 499 +++++++++++++++=
++++++
 7 files changed, 680 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/metag/pdc-intc.txt
 create mode 100644 drivers/irqchip/irq-imgpdc.c


--xaVKES4ML4kOhJbBMMU2BjtbCXlJ4J3bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSLewbAAoJEKHZs+irPybfRSUP/39Ud+e+1ilv7BI3DIKvbyql
DomQ+UgJUUskPwADW5QGRq42ueZITS+eEflotKKa+jIr9fTYguSnrttW1LqPyLOv
//yBmNI9COTUrquhLbo8kkAs1CPo0Wozf1v4B7nCO3Zl2AI7x5GPc5dp7sAKcNNX
N0aJ0EwH23udmjIwdh3K1pypiB8MFXXqhBCyThvKb0g/ZQ+JhRAAbA37n3aovUpz
1u/4RbMf+nXJu797utsrSebBhvoueMmUrG0+/H9uFojvbTUtipJy32Vup0yfXUF8
jvnt4BhGQuYvQv7MGzFqMl24yhsqLb4J3qNowmC6mtV+mYGoQruHzDIrUKaprAQo
UppmEQiIsdoutjcWm9tgV5YkcE/SGdoleFY/OF8aP5sJXzPvf9hzP6qT+39y0rD3
ajHMGB/8rrUXIuT2jb7rETNBxHes6QhZ02BjPUzg4mwbEo1RIpfoK9Hps2EKqLCG
T2Bo3hKBQKoLFwm4W5dgzhMyeCcgk6xohXrQdM8LN0HTm3XfAz8opbIpWDfpK8fP
yCoxARpzif4LMkGmO0sUMVS9PQfjWPRuZ0d/aQtcqxh6Hr3r+j+eRjYPHqrI0mnW
596ucqBp0Qf1ij4h9cwdJQXC+k9QLQ3cb5dLSJK6WCJnO1/XKCd1lLO7ofX/u8Dg
InM+ls9hH6wMvzrg8Z9a
=MyaN
-----END PGP SIGNATURE-----

--xaVKES4ML4kOhJbBMMU2BjtbCXlJ4J3bB--

