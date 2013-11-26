Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3KZQRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:17:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57882 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3KZQRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:17:08 -0500
Date: Tue, 26 Nov 2013 16:17:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] mfd: Single patch bound for v3.13-fixes
Message-ID: <20131126161701.GA4601@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

As requested.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/mfd-lee-3.13-fixes-1

for you to fetch changes up to 72ac01274a8e03eb39756284edb4aa2804599d23:

  mfd: Make MFD_AS3722 depend on I2C=y (2013-11-26 09:12:19 +0000)

----------------------------------------------------------------
A single patch due in for v3.13-rc2

----------------------------------------------------------------
Michal Marek (1):
      mfd: Make MFD_AS3722 depend on I2C=y

 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
