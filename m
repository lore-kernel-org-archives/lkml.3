Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3KSQIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:08:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49247 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab3KSQFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:05:18 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] *** SUBJECT HERE ***
Date: Tue, 19 Nov 2013 16:03:59 +0000
Message-Id: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Small patch series adding some missing functionality on
the WM5110. Given most of the changes are in ASoC I have
generated the patches against Mark's tree but let me know
if we want to push them through MFD instead and I can
regenerate, but I suspect they will cause less conflicts
going through ASoC.

Thanks,
Charles

Charles Keepax (3):
  mfd: wm5110: Make DSP memories readable
  ASoC: wm5110: Add basic support for ISRCs
  ASoC: wm5110: Expose input high pass filter controls

Mark Brown (1):
  ASoC: wm5110: Hook up ADSP2 cores

 drivers/mfd/wm5110-tables.c           |   73 +++++++-
 include/linux/mfd/arizona/registers.h |   37 ++++
 sound/soc/codecs/Kconfig              |    2 +
 sound/soc/codecs/arizona.c            |   10 +
 sound/soc/codecs/arizona.h            |    1 +
 sound/soc/codecs/wm5110.c             |  316 ++++++++++++++++++++++++++++++++-
 6 files changed, 433 insertions(+), 6 deletions(-)

-- 
1.7.2.5

