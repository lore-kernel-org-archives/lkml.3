Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaJHUgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:36:19 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53242 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:36:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 7/7] ARM64: SoC changes for 3.18
Date: Wed, 08 Oct 2014 22:36:15 +0200
Message-ID: <2440106.3HoFFHSvh9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mohIaGRcOkS8sjTnjObcAvrdNWEs6HDzi6W2udrGSJB
 jeFkgkun9WwUyt61aTiOHXxP3bSy4Tt99UUNGav76tPRNb4wUV
 /ArhwVA/ePOLu5CZ2WxI1dOL+5mQyTaXaKASoy5f+LiSL5RwoM
 roiI2c8plqxeQiToIcvIzVIOOc4lOb0PbBcnEvIMsJPrTa7XDC
 HrypCZNjp0XIgrz4UuWWZQGHx+kCYeuP6Q9v3l7ygtB/mzebs0
 xE++voTSVYf48F5m1cW05wv/F7sR0CibfiBaJJ0S7/hvpLMKaP
 oB/8S+qlb7AOzb4kWSAkiOJo7FRljtCwRnCkyXMmGBFeSKd1fm
 nvyBj8R2QMbD7CaB4vNs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/arm64-for-linus

for you to fetch changes up to 18ef9fefd3ef73279cd144bdb24cfd2683ff0492:

  arm64, defconfig: Enable Cavium Thunder SoC in defconfig (2014-10-02 17:38:55 +0200)

----------------------------------------------------------------
ARM64: SoC changes for 3.18

Starting with 3.18, we are merging SoC-specific changes for arm64 through
the arm-soc tree, like we have been doing for arm32.

This time, there is only one set of changes, adding support for the
Cavium "Thunder" Soc family. Since the changes are relatively small,
this includes Kconfig, defconfig and DT changes.

If all goes well, we will never require adding actual C source code
for platform support in arm64, given that the architecture is more
clearly defined and we have moved out a lot of the platform specifics
into device drivers for arm32 already.

----------------------------------------------------------------
Radha Mohan Chintakuntla (3):
      arm64, thunder: Add initial dts for Cavium Thunder SoC
      arm64, thunder: Document devicetree bindings for Cavium Thunder SoC
      arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family

Robert Richter (1):
      arm64, defconfig: Enable Cavium Thunder SoC in defconfig

 .../devicetree/bindings/arm/cavium-thunder.txt     |  10 +
 Documentation/devicetree/bindings/arm/cpus.txt     |   1 +
 arch/arm64/Kconfig                                 |   5 +
 arch/arm64/boot/dts/Makefile                       |   1 +
 arch/arm64/boot/dts/thunder-88xx.dts               |  67 ++++
 arch/arm64/boot/dts/thunder-88xx.dtsi              | 401 +++++++++++++++++++++
 arch/arm64/configs/defconfig                       |   1 +
 7 files changed, 486 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dtsi

