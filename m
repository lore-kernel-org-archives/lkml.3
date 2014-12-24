Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLXVWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:22:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaLXVWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:22:31 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Thu, 25 Dec 2014 08:20:51 +1100
Subject: [PATCH 0/3] Convert omap_hsmmc to use common devicetree parsing
 code.
Cc: GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141224211653.30499.46669.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend against latest
  git://git.linaro.org/people/ulf.hansson/mmc next

with requested changes.

My goal is to get omap_hsmmc to use the common code for parsing of,
particularly so that I can set "cap-power-off-card", which omap_hsmmc
doesn't explicitly report.

Thanks,
NeilBrown



---

NeilBrown (3):
      mmc: core: Allow host driver to provide isr for card-detect interrupts.
      mmc: omap_hsmmc: use slot-gpio library for gpio support.
      mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configuration.


 drivers/mmc/core/slot-gpio.c  |   20 ++++++++
 drivers/mmc/host/omap_hsmmc.c |  100 +++++++++--------------------------------
 include/linux/mmc/slot-gpio.h |    2 +
 3 files changed, 43 insertions(+), 79 deletions(-)

--
Signature

