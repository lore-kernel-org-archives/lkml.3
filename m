Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaH1Pmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:42:40 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:42453 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaH1Pmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:42:39 -0400
Date: Thu, 28 Aug 2014 16:42:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fixes for Backlight due for the v3.17 -rcs
Message-ID: <20140828154233.GW24579@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-fixes-3.17

for you to fetch changes up to 937222c4dda495277a8dfbc18bf7e54fe670105c:

  pwm-backlight: Fix bogus request for GPIO#0 when instantiated from DT (2014-08-20 13:23:00 +0100)

----------------------------------------------------------------
One simple fix to invalidate GPIO non-request.
----------------------------------------------------------------
Lothar Waßmann (1):
      pwm-backlight: Fix bogus request for GPIO#0 when instantiated from DT

 drivers/video/backlight/pwm_bl.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
