Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaEQXyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 19:54:35 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:43543 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEQXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 19:54:34 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Fix coding style of if statement
Date: Sun, 18 May 2014 00:54:28 +0100
Message-Id: <1400370871-26361-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the modified patches of
[PATCH x/4] Fix coding style of if statment

The following pateches fix the errors and warnings below in 
dgnc_neo.c and dgnc_tty.c to meet kernel coding style.

ERROR: else should follow close brace '}'
ERROR: that open brace { should be on the previous line
WARNING: line over 80 characters
WARNING: braces {} are not necessary for single statement blocks

Masaru Nomura (3):
  staging: dgnc: Put else statements on the right line
  staging: dgnc: dgnc_neo: Clean up if statement
  staging: dgnc: Remove extra curly braces

 drivers/staging/dgnc/dgnc_neo.c |  112 +++++++++++--------------------
 drivers/staging/dgnc/dgnc_tty.c |  140 ++++++++++++++-------------------------
 2 files changed, 88 insertions(+), 164 deletions(-)

-- 
1.7.9.5

