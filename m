Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbaJaVsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:48:30 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:56196 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbaJaVs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:48:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsNAKkCVFRXQwLV/2dsb2JhbABcgw67FwUBdJoagRoXAQEBAQF9hF8jgRqIfAG8PI8UhjeKWR2ENQWGMZdHlkiBRwGCMTyCegEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/8] cdrom: sysctl export + clean-up
Date: Fri, 31 Oct 2014 22:47:56 +0100
Message-Id: <1414792084-7739-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves sysctl functions to a new file cdrom_sysctl.c
and tries to solve small code / coding style issues.

Fabian Frederick (8):
  cdrom: include linux/uaccess.h instead of asm/uaccess.h
  cdrom: use static const char * const where possible
  cdrom: fix spaces required errors
  cdrom: move EXPORT_SYMBOL after functions
  cdrom: remove bool comparison/assignment to 0/1
  cdrom: use bool for true/false initialized variable
  cdrom: cdrom: export sysctl code
  cdrom: fix init_cdrom_command in dvd_do_auth

 drivers/cdrom/Makefile       |   1 +
 drivers/cdrom/cdrom.c        | 425 ++++++-------------------------------------
 drivers/cdrom/cdrom_sysctl.c | 297 ++++++++++++++++++++++++++++++
 include/linux/cdrom.h        |  33 ++++
 4 files changed, 382 insertions(+), 374 deletions(-)
 create mode 100644 drivers/cdrom/cdrom_sysctl.c

-- 
1.9.3

