Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaKJUWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:22:11 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:26770 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaKJUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:22:08 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscNAMAdYVRXQ4qy/2dsb2JhbABcgw65SgsFAQVvmiyBKRcBAQEBAX2EXyOBGoh8Ab0ckCuGOopbHYQ1BYY6l2uWYIFHAYIzPIJ6AQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 00/10 linux-next] cdrom: sysctl export + clean-up
Date: Mon, 10 Nov 2014 21:21:45 +0100
Message-Id: <1415650916-9975-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves sysctl functions to a new file cdrom_sysctl.c
and tries to solve small code / coding style issues.

V2:
        -Use cdrom_ prefix for global variables
                (suggested by Joe Perches)
        -Add 2 patches

Fabian Frederick (10):
  cdrom: include linux/uaccess.h instead of asm/uaccess.h
  cdrom: use static const char * const where possible
  cdrom: fix spaces required errors
  cdrom: move EXPORT_SYMBOL after functions
  cdrom: remove bool comparison/assignment to 0/1
  cdrom: use bool for true/false initialized variable
  cdrom: export sysctl code
  cdrom: fix init_cdrom_command in dvd_do_auth
  cdrom: remove unnecessary status
  cdrom: uniformize lba command initialization

 drivers/cdrom/Makefile       |   1 +
 drivers/cdrom/cdrom.c        | 471 +++++++------------------------------------
 drivers/cdrom/cdrom_sysctl.c | 297 +++++++++++++++++++++++++++
 include/linux/cdrom.h        |  33 +++
 4 files changed, 401 insertions(+), 401 deletions(-)
 create mode 100644 drivers/cdrom/cdrom_sysctl.c

-- 
1.9.1

