Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaECKs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:48:58 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54002 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaECKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:48:56 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-doc@vger.kernel.org, Sonal Santan <sonal.santan@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/2] Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
Date: Sat,  3 May 2014 12:47:55 +0200
Message-Id: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add dell-smo8800.ko driver and update program hpfall.c

Pali Rohár (2):
  platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI
    SMO8800/SMO8810)
  Documentation: Rename hpfall.c => freefall.c, fixes for Dell

 Documentation/laptops/00-INDEX      |    4 +-
 Documentation/laptops/freefall.c    |  171 +++++++++++++++++++++++
 Documentation/laptops/hpfall.c      |  146 --------------------
 drivers/platform/x86/Kconfig        |   10 ++
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/dell-smo8800.c |  253 +++++++++++++++++++++++++++++++++++
 6 files changed, 437 insertions(+), 148 deletions(-)
 create mode 100644 Documentation/laptops/freefall.c
 delete mode 100644 Documentation/laptops/hpfall.c
 create mode 100644 drivers/platform/x86/dell-smo8800.c

-- 
1.7.9.5

