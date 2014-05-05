Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaEEUHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:07:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40298 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaEEUG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:06:58 -0400
Date: Mon, 5 May 2014 15:06:35 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL #2/2] ARM: dts: DRA7/AM437x l3noc dts updates
Message-ID: <20140505200635.GB9863@kahuna>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
 <20140505200322.GA9863@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140505200322.GA9863@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

   Please pull the following to the dts support of AM437x and DRA7
   support for l3_noc for the upcoming 3.16 window. This series was posted
   http://marc.info/?l=linux-omap&m=139750288003978&w=2 and the
   functionality enabled by the first pull request for driver.

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  https://github.com/nmenon/linux-2.6-playground.git pull/l3noc/dts-fixes

for you to fetch changes up to 2eeddb8a5356e088021a8dd84de870de89bf793d:

  ARM: dts: AM4372: add l3-noc information (2014-05-05 14:35:29 -0500)

----------------------------------------------------------------
Afzal Mohammed (1):
      ARM: dts: AM4372: add l3-noc information

Rajendra Nayak (1):
      ARM: dts: DRA7: Use dra7-l3-noc instead of omap4-l3-noc

 arch/arm/boot/dts/am4372.dtsi |    6 +++++-
 arch/arm/boot/dts/dra7.dtsi   |    6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)
-- 
Regards,
Nishanth Menon
