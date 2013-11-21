Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3KUJIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:08:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55072 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KUJHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:07:32 -0500
Date: Thu, 21 Nov 2013 09:07:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] mfd: Immutable branch for ASoC
Message-ID: <20131121090724.GB19368@lee--X1>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
 <20131120102045.GW2674@sirena.org.uk>
 <20131120104526.GA30524@lee--X1>
 <20131120113400.GY2674@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131120113400.GY2674@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, add my ack and give me a signed tag to pull from please.

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/ib-asoc-1

for you to fetch changes up to 934156639dc0802a890aeba6057f7de7de84e02d:

  ASoC: wm5110: Expose input high pass filter controls (2013-11-21 08:59:57 +0000)

----------------------------------------------------------------
ASoC immutable branch, as requested by Mark Brown.
----------------------------------------------------------------
Charles Keepax (1):
      ASoC: wm5110: Expose input high pass filter controls

 drivers/mfd/wm5110-tables.c           |  4 ++++
 include/linux/mfd/arizona/registers.h | 37 +++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/arizona.c            | 10 ++++++++++
 sound/soc/codecs/arizona.h            |  1 +
 sound/soc/codecs/wm5110.c             | 19 +++++++++++++++++++
 5 files changed, 71 insertions(+)


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
