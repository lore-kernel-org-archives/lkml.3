Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaGaNRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:17:12 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:44912 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751167AbaGaNRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:17:08 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2014 09:17:08 EDT
From: Jeremy Vial <jvial@adeneo-embedded.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Manage OMAP34xx ES3.1.2 rev to resume from suspend
Date: Thu, 31 Jul 2014 15:10:32 +0200
Message-Id: <1406812234-23163-1-git-send-email-jvial@adeneo-embedded.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My kernel crashed when my OMAP34xx ES3.1.2 leave suspend mode. The first
patch seems to solve the issue, and the second one corrects Linux kernel
coding style problems.

Jeremy Vial (2):
  ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX
    rev3.1.2 case.
  ARM: OMAP3: Fix coding style problems in
    arch/arm/mach-omap2/control.c

 arch/arm/mach-omap2/control.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.9.5

