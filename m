Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbaEQQdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:33:22 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:37081 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964773AbaEQQdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:33:21 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 0/4] Fix coding style of if statement
Date: Sat, 17 May 2014 17:30:50 +0100
Message-Id: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following pateches fix the errors and warnings in 
dgnc_neo.c and dgnc_tty.c to meet kernel coding style.

ERROR: else should follow close brace '}'
ERROR: that open brace { should be on the previous line
WARNING: line over 80 characters
WARNING: braces {} are not necessary for single statement blocks

Masaru Nomura (4):
  staging: dgnc: Fix indenting of if-else statement
  staging: dgnc: dgnc_neo: Fix indenting of if statement
  staging: dgnc: dgnc_neo: Fix conditional part of if statement
  staging: dgnc: Remove unnecessary braces

 drivers/staging/dgnc/dgnc_neo.c |   67 ++++++++++++++-------------------------
 drivers/staging/dgnc/dgnc_tty.c |   42 ++++++++----------------
 2 files changed, 38 insertions(+), 71 deletions(-)

-- 
1.7.9.5

