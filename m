Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3BML2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:28:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:30073 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765Ab3BML2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:28:13 -0500
Message-ID: <511B78C5.5030209@atmel.com>
Date: Wed, 13 Feb 2013 12:28:05 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Wu, Josh" <Josh.wu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [GIT PULL] at91: more DT changes related to MTD for 3.9
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof, Arnd,

I would like you to consider this little pull request for modification of some
AT91 Device Tree files.
We have had a discussion about this material earlier and now that Artem has queued
the driver modifications for MTD, I would like to know if it is possible to
add these two patches in your late/dt branch?

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt-late

for you to fetch changes up to c18c6b29e0d8aa6a14ae0f254c5e7abe41a01745:

  ARM: at91: at91sam9n12: add DT parameters to enable PMECC (2013-02-07 16:45:06 +0100)

----------------------------------------------------------------
More DT modifications for AT91. Now that I am sure that
the drivers modification are picked-up by MTD.
Changes the use ECC to hardware ECC (named PMECC) for
SoCs that are using it and their associated Evaluation Kits:
- at91sam9x5-ek
- at91sam9n12-ek

----------------------------------------------------------------
Josh Wu (2):
      ARM: at91: at91sam9x5: add DT parameters to enable PMECC
      ARM: at91: at91sam9n12: add DT parameters to enable PMECC

 arch/arm/boot/dts/at91sam9n12.dtsi  | 3 ++-
 arch/arm/boot/dts/at91sam9n12ek.dts | 5 ++++-
 arch/arm/boot/dts/at91sam9x5.dtsi   | 4 ++++
 arch/arm/boot/dts/at91sam9x5cm.dtsi | 5 ++++-
 4 files changed, 14 insertions(+), 3 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
