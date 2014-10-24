Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaJXGxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:53:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:22516 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaJXGxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:53:17 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <khilman@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenyou.yang@atmel.com>
Subject: [PATCH v3 0/3] i2c/at91: add support PM functions
Date: Fri, 24 Oct 2014 14:50:14 +0800
Message-ID: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

The patches is to add the PM functions support for the at91 i2c controller.

It is based on the i2c/for-next branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git.

Best Regards,
Wenyou Yang

------
Change log:
v2.0

According to the advice from Kevin Hilman, 
1./ Wrap the runtime suspend/resume functions in CONFIG_PM instead of CONFIG_PM_RUNTIME.
2./ Call the runtime suspend/resume functions directly in the system suspend/resume.

v3.0
   Covert the system suspend/resume to suspend_noirq/resume_noirq.

Wenyou Yang (3):
  i2c/at91: add support for runtime PM
  i2c/at91: add support for system PM
  i2c/at91: adopt pinctrl support

 drivers/i2c/busses/i2c-at91.c |   71 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 6 deletions(-)

-- 
1.7.9.5

