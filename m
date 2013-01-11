Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3AKR5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:57:38 -0500
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49173 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3AKR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:57:36 -0500
X-Greylist: delayed 3200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 12:57:36 EST
From: Doug Anderson <dianders@chromium.org>
To: linux-i2c@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [REPOST PATCH 0/2] Add automatic bus number support for i2c busses with device tree
Date: Fri, 11 Jan 2013 09:57:05 -0800
Message-Id: <1357927027-4857-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1353522362-25519-2-git-send-email-dianders@chromium.org>
References: <1353522362-25519-2-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was suggested by Mark Brown in response to a patch for adding
this functionality only for the s3c2410 bus:
  https://lkml.org/lkml/2012/11/20/681

I have also modified the i2c-pxa driver to use this new functionality.
As Haojian Zhuang has Acked this patch, I believe that this has now
been tested.

Reposting (with Haojian Zhuang's ack) in the hopes that a maintainer
will pick it up.  :)


Doug Anderson (2):
  i2c-core: dt: Pick i2c bus number from i2c alias if present
  i2c: pxa: Use i2c-core to get bus number now

 drivers/i2c/busses/i2c-pxa.c |    8 +---
 drivers/i2c/i2c-core.c       |  105 ++++++++++++++++++++++++++++++-----------
 2 files changed, 78 insertions(+), 35 deletions(-)

-- 
1.7.7.3

