Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbaLLS0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:26:50 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61426 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaLLS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:26:48 -0500
From: Eduardo Valentin <edubezval@gmail.com>
To: Linux PM <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 0/2] Fix message outputing when failing to register cpu cooling
Date: Fri, 12 Dec 2014 10:14:23 -0400
Message-Id: <1418393665-16850-1-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Similar to the IMX case, other two drivers may require to avoid printing
error messages when PROBE DEFER happens.

http://marc.info/?l=linux-pm&m=141833235831158&w=2

This minor series fix them.

Cheers,

Eduardo Valentin (2):
  thermal: db8500: Do not print error message in the EPROBE_DEFER case
  thermal: ti-soc-thermal: Do not print error message in the
    EPROBE_DEFER case

 drivers/thermal/db8500_cpufreq_cooling.c           | 10 ++++++++--
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.1.3

