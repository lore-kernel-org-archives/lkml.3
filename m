Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbaGROL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:11:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52174 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934609AbaGROL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:11:26 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: orjan.eide@arm.com, Punit Agrawal <punit.agrawal@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Convert exynos PPMU driver to be built as module
Date: Fri, 18 Jul 2014 15:09:52 +0100
Message-Id: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's no reason why the exynos PPMU can't be built as a module
except you need -

- The first patch exports the functions that are needed to build
devfreq drivers as modules.

- The second patch then converts the exynos PPMU devfreq driver to be
  built as a module.

Compile tested only.

Thanks

Punit Agrawal (1):
  PM / devfreq: exynos: Enable building exynos PPMU as module

Ørjan Eide (1):
  PM / devfreq: Export helper functions for drivers

 drivers/devfreq/Kconfig              |    2 +-
 drivers/devfreq/devfreq.c            |    3 +++
 drivers/devfreq/exynos/exynos_ppmu.c |    3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

-- 
1.7.10.4

