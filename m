Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452Ab3FSJyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:54:46 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46417 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934149Ab3FSJym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:54:42 -0400
Date: Wed, 19 Jun 2013 10:54:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, weiyj.lk@gmail.com
Subject: [GIT PULL] mfd: for-next from Lee
Message-ID: <20130619095436.GG22998@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

Just a small pre-vacation pull-request for MFD:

The following changes since commit e578438820cdca91cb5eab477ec062236433ce5f:

  mfd: ssbi: Use devm_* and simplify code (2013-06-18 09:41:15 +0200)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd-next

for you to fetch changes up to 3f9850f26241f1d4f9ed49eaa70e043a3bb24a7c:

  mfd: htc-egpio: Use devm_ioremap_nocache() instead of ioremap_nocache() (2013-06-19 09:53:55 +0100)

----------------------------------------------------------------
Sachin Kamat (1):
      mfd: davinci_voicecodec: Convert to use devm_* APIs

Wei Yongjun (1):
      mfd: htc-egpio: Use devm_ioremap_nocache() instead of ioremap_nocache()

 drivers/mfd/davinci_voicecodec.c       | 48 ++++++++++--------------------------------------
 drivers/mfd/htc-egpio.c                |  4 ++--
 include/linux/mfd/davinci_voicecodec.h |  2 --
 3 files changed, 12 insertions(+), 42 deletions(-)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
