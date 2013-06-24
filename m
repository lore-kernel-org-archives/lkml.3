Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3FXJIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:08:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16029 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3FXJIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:08:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/3] ARM: at91/PMC: some fixes for clock functionalies
Date: Mon, 24 Jun 2013 11:08:44 +0200
Message-ID: <cover.1372064763.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that some errors where made when affecting some functionalies to SoCs.

Please review this quickly as I do want to send these fixes for next merge
window with will open soon.

Best regards,

Nicolas Ferre (3):
  ARM: at91/PMC: sama5d3 family doesn't have a PLLB
  ARM: at91/PMC: at91sam9n12 family have a PLLB
  ARM: at91/PMC: at91sam9n12 family has USB HS feature

 arch/arm/mach-at91/clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.2.2

