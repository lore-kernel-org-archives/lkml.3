Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaDENFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 09:05:47 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:33891 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaDENFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 09:05:42 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <stable@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/2] ARC: unbork nsimosci serial console
Date: Sat, 5 Apr 2014 18:35:07 +0530
Message-ID: <1396703109-7927-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is basically stable team fodder. I'll be sending these patches to
Linus as part of ARC 3.15 merge window changes early next week.

Thx,
-Vineet

Mischa Jonker (1):
  ARC: [nsimosci] Change .dts to use generic 8250 UART

Vineet Gupta (1):
  ARC: [nsimosci] Unbork console

 arch/arc/boot/dts/nsimosci.dts      | 12 +++++++-----
 arch/arc/configs/nsimosci_defconfig |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.3.2

