Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaFEVYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:24:24 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64999 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaFEVYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:24:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3] mfd randconfig fixes
Date: Thu,  5 Jun 2014 23:24:11 +0200
Message-Id: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:G0A/XhdDPccVCHmhWp7vUKjgK1OoterTmEpnlhX+RjC
 B3DtLtXDQQmUC6W9kGN8JcFjAgZMc3zYR/tMiHtqY1mfr4ccRA
 ZwklRsCp9aECf0LEeo995OGbKJ4yUY81CL85tZMCCcd0izxWFW
 sZXzZJvjeoqUAVX5F7/du7VIGnuZpK+AZO5eJieNz7+MdnZO9h
 okzzrL61ozH5c3YLJVivJlV8ngRalYqO/jg/sUX5r6UV3+9q0E
 vN2+xOru4tLjbBBt5M3pBfIAJj1UM6hHymMXlMeKIKklEkDjms
 BXaQND9HFE9Y0pvj3nI4LLBwaJqHcbqldpPmhyH1Jj7lGf/d95
 6ruzbQlMGIe0EKvesQkKLoL4vNBlTGINbQMVPPivq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel and Lee,

Here are three small bug fixes for problems I found during
randconfig testing in MFD. Please apply to an appropriate
tree.

Arnd Bergmann (3):
  mfd: UCB1x00: enable modular build
  mfd: davinci voicecodec need regmap_mmio
  mfd: STw481x: allow modular build

 drivers/mfd/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.8.3.2

