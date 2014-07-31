Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaGaVVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:21:45 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:14362 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbaGaVVm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:21:42 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=gM9dd3at8zUA:10 a=IkcTkHD0fZMA:10 a=7iGUb45sqrSdrWPWihEA:9
 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAByy2lPD7hTT/2dsb2JhbABbgw2EIaxiAQEBCaUBgQ0Wd4QtVhUgAhgOAmAjiDWrPogHhn+QYReBLIRQhiGDL4MAgVIFl0uYf4NLOw
Date: Thu, 31 Jul 2014 23:21:40 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: richard@nod.at, pebolle@tiscali.nl
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <760230076.57448.1406841700324.open-xchange@webmail.nmp.skynet.be>
Subject: SH 7619 CHCR values
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 Could you tell me where I could find SH 7619 CHCR values in order to solve the
following errors ?     

arch/sh/drivers/dma/dma-sh.c: In function 'calc_xmit_shift':
arch/sh/drivers/dma/dma-sh.c:97:21: error: 'CHCR_TS_LOW_MASK' undeclared (first
use in this function)
arch/sh/drivers/dma/dma-sh.c:97:21: note: each undeclared identifier is reported
only once for each function it appears in
arch/sh/drivers/dma/dma-sh.c:97:42: error: 'CHCR_TS_LOW_SHIFT' undeclared (first
use in this function)
arch/sh/drivers/dma/dma-sh.c:98:12: error: 'CHCR_TS_HIGH_MASK' undeclared (first
use in this function)
arch/sh/drivers/dma/dma-sh.c:98:34: error: 'CHCR_TS_HIGH_SHIFT' undeclared
(first use in this function)
arch/sh/drivers/dma/dma-sh.c: In function 'sh_dmac_configure_channel':
arch/sh/drivers/dma/dma-sh.c:145:10: error: 'CHCR_TS_LOW_SHIFT' undeclared
(first use in this function)
arch/sh/drivers/dma/dma-sh.c:145:10: error: 'CHCR_TS_HIGH_SHIFT' undeclared
(first use in this function)

I guess it should be added in a new dma-register.h in arch/sh/include/cpu-sh2 ?

Regards,
Fabian
