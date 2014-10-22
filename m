Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaJVTNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:13:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41300 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaJVTNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:21 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] More eeepc-laptop cleanup
Date: Wed, 22 Oct 2014 21:12:35 +0200
Message-Id: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is another round of cleanups in eeepc-laptop. It's mostly shuffling around
stuff, no big things. It's been running on my eeepc for two or three weeks now
without any apparent problems. Comments appreciated.

Thanks,
Frans

Frans Klaver (8):
  eeepc-laptop: flatten control flow
  eeepc-laptop: don't break user visible strings
  eeepc-laptop: define rfkill notifier nodes only once
  eeepc-laptop: pull out eeepc_destroy_rfkill
  eeepc-laptop: clean up control flow in eeepc_acpi_notify
  eeepc-laptop: replace magic numbers with defines
  eeepc-laptop: document fan_pwm conversions
  eeepc-laptop: don't assume get_acpi succeeds

 drivers/platform/x86/eeepc-laptop.c | 244 +++++++++++++++++++-----------------
 1 file changed, 127 insertions(+), 117 deletions(-)

-- 
2.1.0

