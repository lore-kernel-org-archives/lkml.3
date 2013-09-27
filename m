Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3I0NZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:25:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab3I0NZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:25:22 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] regulator: ti-abb: misc fixes
Date: Fri, 27 Sep 2013 08:25:12 -0500
Message-ID: <1380288314-24064-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following are a couple of fixes for ti-abb regulator based on
updated I documentation and tests.


Based on v3.12-rc2 tag. These fixes could be punted to 3.13-rc1 as the
current OMAP support in master is not ready for use yet.

Nishanth Menon (2):
  regulator: ti-abb: skip optional parameter for ldo-address
  regulator: ti-abb: Fix bias voltage glitch in transition to bypass
    mode with ldo voltage override

 drivers/regulator/ti-abb-regulator.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
1.7.9.5

Regards,
Nishanth Menon
