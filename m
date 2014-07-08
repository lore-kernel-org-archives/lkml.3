Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaGHXHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:07:17 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61995 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGHXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:07:12 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
Subject: [PATCH 0/3] Add support for Technologic Systems TS-5400
Date: Tue,  8 Jul 2014 18:57:46 -0400
Message-Id: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset extends the TS-5500 platform driver to support the very similar
Technologic Systems TS-5400 board (like the others from the TS-5x00 serie).

The TS-5400 also has 2 GPIO blocks, which will be declared in a future patch,
once the gpio-ts5500 driver will be modified accordingly.

Vivien Didelot (3):
  x86: (ts5500) use DEVICE_ATTR_RO macro
  x86: (ts5500) add a name attribute
  x86: (ts5500) add support for TS-5400

 Documentation/ABI/testing/sysfs-platform-ts5500 |  7 ++
 arch/x86/platform/ts5500/ts5500.c               | 94 ++++++++++++++-----------
 2 files changed, 60 insertions(+), 41 deletions(-)

-- 
1.9.1

