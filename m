Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaFQOpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:45:08 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36023 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbaFQOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:45:06 -0400
Date: Tue, 17 Jun 2014 15:44:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [GIT PULL] Mark and Chanwoo: Immutable branch between MFD, Extcon
 and Regulator
Message-ID: <20140617144459.GG29841@lee--X1>
References: <1400655168-19739-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400655168-19739-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Chanwoo,

I've applied both Robert's patches with the appropriate Acks. If you
wish to apply them to your trees in order to avoid conflicts at merge
time, this is the branch yo need to pull from:

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-extcon-regulator-v3.17

for you to fetch changes up to 342d669c1ee421323f552a62729d3a3d0065093c:

  mfd: max77693: Handle IRQs using regmap (2014-06-17 15:17:00 +0100)

----------------------------------------------------------------
Immutable branch between MFD, Extcon and Regulator due for v3.17

----------------------------------------------------------------
Robert Baldyga (2):
      mfd: max77693: Remove unnecessary wrapper functions
      mfd: max77693: Handle IRQs using regmap

 drivers/extcon/extcon-max77693.c     |  35 ++--
 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/Makefile                 |   2 +-
 drivers/mfd/max77693-irq.c           | 336 -----------------------------------
 drivers/mfd/max77693.c               | 210 +++++++++++++++-------
 drivers/regulator/max77693.c         |  12 +-
 include/linux/mfd/max77693-private.h |  54 ++++--
 7 files changed, 217 insertions(+), 433 deletions(-)
 delete mode 100644 drivers/mfd/max77693-irq.c

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
