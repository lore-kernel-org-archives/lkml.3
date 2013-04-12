Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3DLWne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:43:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3DLWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:43:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,465,1363158000"; 
   d="scan'208";a="38197144"
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm defconfig for 3.10
In-Reply-To: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
From: David Brown <davidb@codeaurora.org>
Date: Fri, 12 Apr 2013 15:43:32 -0700
Message-ID: <8yavc7rpdyj.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-defconfig-3.10

for you to fetch changes up to dd465b2400a77bea6e5a95045feb6dbcf2e48a38:

  ARM: msm: enable SSBI driver in defconfig (2013-03-12 11:14:32 -0700)

----------------------------------------------------------------
Defconfig updates for MSM

The msm_defconfig is quite out of date.  This allows the targets we
are actively working on to be more easily build and run tested.

----------------------------------------------------------------
David Brown (1):
      ARM: msm: enable SSBI driver in defconfig

Stephen Boyd (1):
      ARM: msm: Concentrate defconfig on DT supported devices

 arch/arm/configs/msm_defconfig | 154 +++++++++++++++++++++++++++++------------
 1 file changed, 109 insertions(+), 45 deletions(-)

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
