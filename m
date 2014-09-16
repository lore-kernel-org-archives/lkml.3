Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaIPLHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:07:46 -0400
Received: from sesbmg23.ericsson.net ([193.180.251.37]:48076 "EHLO
	sesbmg23.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaIPLHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:07:45 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 07:07:44 EDT
X-AuditID: c1b4fb25-f791c6d00000617b-fd-541816794e69
From: Oscar Utbult <oscar@oscr.io>
To: <broonie@kernel.org>, <rdunlap@infradead.org>
CC: <linux-spi@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <oscar@oscr.io>
Subject: [PATCH 1/1] spi-summery: documentation mistake
Date: Tue, 16 Sep 2014 12:52:13 +0200
Message-ID: <1410864733-861751-1-git-send-email-oscar@oscr.io>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsUyM+JvjW6lmESIwYznqhZTHz5hs1jYtoTF
	4vKuOWwWjR9vslvM+XWazeLtneksDmwem1doeWxa1cnmcfzkBnaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJOLrzEWvCOtWLK8yPsDYyvWboYOTkkBEwk1u6ZyQxhi0lcuLeerYuRi0NI4CijxLWH
	1xghnF2MEgs+LmOGcM4xSszZs4wdwmlglPh84RMTSD+bgJLEn8Z97CC2iIChRNvjuYwgNrNA
	vsSHk/fBdggLmEs0bjkIZrMIqEo8aN8GVs8rYCfx8PwkqDsUJE6/u8sCEReUODnzCQvEHAmJ
	gy9eANVwAC1Wk1h4umACo8AsJFWzkFQtYGRaxShanFqclJtuZKyXWpSZXFycn6eXl1qyiREY
	uge3/FbdwXj5jeMhRgEORiUeXgUuiRAh1sSy4srcQ4zSHCxK4rwLz80LFhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cAoWXLo9ffSbarF/tyvPAwvJ+ksfzkhMVh/wmGxhXY+4gf/xs9Qd622
	ebpLyFxvT328WPMHlWjf9Zu4Eu4aXshqTmX488T2nfmWDF/booPeHH1L/q/6GWd2fVak7Jy2
	VKmWXx94LTOTvvRnKeZwCTGtsvFx5Z7VO3ffxSNyK3Ryfp/1ea9QW6jEUpyRaKjFXFScCAC4
	SHVfPgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contributors are not listed in alphabetical order as claimed by documentation.

Signed-off-by: Oscar Utbult <oscar@oscr.io>
---
 Documentation/spi/spi-summary | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index 7982bcc..d29734b 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -601,13 +601,13 @@ THANKS TO
 Contributors to Linux-SPI discussions include (in alphabetical order,
 by last name):
 
+Mark Brown
 David Brownell
 Russell King
+Grant Likely
 Dmitry Pervushin
 Stephen Street
 Mark Underwood
 Andrew Victor
-Vitaly Wool
-Grant Likely
-Mark Brown
 Linus Walleij
+Vitaly Wool
-- 
1.8.0.1

