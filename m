Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbaFINUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:20:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36474 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbaFINUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:20:09 -0400
Message-ID: <5395B482.2010809@ti.com>
Date: Mon, 9 Jun 2014 16:20:02 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [GIT PULL] omap DT fbdev changes for 3.16
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="eeEqLOdxGBkDHGrTXvFpngLLk3JONGgQO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eeEqLOdxGBkDHGrTXvFpngLLk3JONGgQO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are display related device tree data changes for OMAP. They are base=
d on
an already merged branch to satisfy the dependencies for the .dts file ch=
anges.

 Tomi

The following changes since commit 43369f0fe81044427f6b1eedeb16bf8c74c86d=
48:

  Merge branch 'for-v3.16/clk-dt' of https://github.com/t-kristo/linux-pm=
 into omap-for-v3.16/dt-v2 (2014-05-28 10:14:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-omap-dt-3.16

for you to fetch changes up to 7d0fde3986c35dc1400cb552776c0a640ac354d7:

  ARM: omap5.dtsi: Add audio related parameters to hdmi node (2014-06-03 =
10:22:24 +0300)

----------------------------------------------------------------
fbdev changes for 3.16 (omap devicetree)

Add OMAP DT data:

* omap5 display subsystem
* display data for omap5 uEVM board
* am43xx display subsystem
* display data for am43xx ePOS and GP boards (LCD only)
* display data for GTA04 board
* display data for overo board
* display data for duovero-parlor board
* display data for omap3 evm and ldp boards

----------------------------------------------------------------
Florian Vaussard (4):
      ARM: dts: overo: Add support for DVI output
      ARM: dts: overo: Add support for 4.3'' LCD output
      ARM: dts: overo: Add support for 3.5'' LCD output
      ARM: dts: duovero-parlor: Add HDMI output

Jyri Sarha (2):
      ARM: omap4.dtsi: Add audio related parametes to hdmi node
      ARM: omap5.dtsi: Add audio related parameters to hdmi node

Marek Belisko (1):
      ARM: dts: omap3-gta04: Add display support

Sathya Prakash M R (2):
      ARM: dts: am4372.dtsi: add DSS information
      ARM: dts: am437x-gp-evm: add LCD data

Tomi Valkeinen (4):
      ARM: dts: am43x-epos-evm: add LCD data
      ARM: dts: omap5.dtsi: add DSS nodes
      ARM: dts: omap5-uevm.dts: add tca6424a
      ARM: dts: omap5-uevm.dts: add display nodes

Tony Lindgren (1):
      ARM: dts: Add LCD panel sharp ls037v7dw01 support for omap3-evm and=
 ldp

 arch/arm/boot/dts/am4372.dtsi                        |  29 +++++++
 arch/arm/boot/dts/am437x-gp-evm.dts                  |  97 +++++++++++++=
++++++++
 arch/arm/boot/dts/am43x-epos-evm.dts                 |  96 +++++++++++++=
++++++++
 arch/arm/boot/dts/omap3-evm-37xx.dts                 |  50 +++++++++++
 arch/arm/boot/dts/omap3-evm-common.dtsi              |  26 ++++++
 arch/arm/boot/dts/omap3-gta04.dts                    |  90 +++++++++++++=
+++++++
 arch/arm/boot/dts/omap3-ldp.dts                      |  29 +++++--
 arch/arm/boot/dts/omap3-overo-alto35-common.dtsi     |   1 +
 arch/arm/boot/dts/omap3-overo-chestnut43-common.dtsi |   1 +
 arch/arm/boot/dts/omap3-overo-common-dvi.dtsi        | 111 +++++++++++++=
+++++++++++
 arch/arm/boot/dts/omap3-overo-common-lcd35.dtsi      | 165 +++++++++++++=
+++++++++++++++++++++++
 arch/arm/boot/dts/omap3-overo-common-lcd43.dtsi      | 178 +++++++++++++=
++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3-overo-gallop43-common.dtsi   |   1 +
 arch/arm/boot/dts/omap3-overo-palo43-common.dtsi     |   1 +
 arch/arm/boot/dts/omap3-overo-summit-common.dtsi     |   1 +
 arch/arm/boot/dts/omap3-overo-tobi-common.dtsi       |   1 +
 arch/arm/boot/dts/omap3-panel-sharp-ls037v7dw01.dtsi |  71 +++++++++++++=
+++
 arch/arm/boot/dts/omap4-duovero-parlor.dts           |  44 ++++++++++
 arch/arm/boot/dts/omap4.dtsi                         |   2 +
 arch/arm/boot/dts/omap5-uevm.dts                     |  87 +++++++++++++=
++++++
 arch/arm/boot/dts/omap5.dtsi                         |  62 +++++++++++++=
+
 21 files changed, 1138 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-overo-common-dvi.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-common-lcd35.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-overo-common-lcd43.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-panel-sharp-ls037v7dw01.dtsi


--eeEqLOdxGBkDHGrTXvFpngLLk3JONGgQO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlbSCAAoJEPo9qoy8lh71mjcP/A+DUTHrKqFH9PeOt7cg+Lot
zF7ahWQDF/FKr1bso7GvMsWb05wSq59gewb5WxLFx2AiYnAZig8sB0sJsNNEK9HJ
0SAFoAs7a8Z1TDReZmRs/Rl1ZahrnyzYzeeGEBUcE/sZbFyQJ+SFsKtmlWwqVHvV
YKySZyKRzVa0CwKAvE0L4eKl4mOIeVvLga63Lo0MXUgfvpPASzo3dhFPFYQcO/u5
UpRpnDmit9mzjWM13g1gMYgr13XLGWkOvD42GO7zNnalTkjf+8tURkUx3uOu+w6w
X4MgoZYtUUbTRpQvnZAWFwg2wDTpOBaVHTFiJ42nsnevu4ibEnwNMWuXMaXembmq
HVjeMAJXL1Euv9x4D6owCSRHZx6eSfLZbfhL+Gnav05OP/Gr40JrI21rhNofuwM2
SRME1jEH8Te+th7kuJdHaaAVmpLkxZevNGizTMRab+SoQkdeVZmWXWIhHweANzla
HFFUsPQOk5nyphpIv7TCviBWXojtmdvXhneXI2pFugslutLg/olVOuTZCoA+Tvp4
w+d+mlOBg+CN0WOKztj6kbvQo58fNtg8qRl0ruCSbqREfep94QNco+nXEHTWxowO
bJmT9aLziK/2EpvhJgreYycav3IRfNLX9P6csA2YIm3Jd65TG1w7LGwAlp4Y3FP1
gIQOJ+SfSD03JAswVumj
=jSj7
-----END PGP SIGNATURE-----

--eeEqLOdxGBkDHGrTXvFpngLLk3JONGgQO--
