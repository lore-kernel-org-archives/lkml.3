Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab3FMSlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:41:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36393 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920Ab3FMSlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:41:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Tony Luck <tony.luck@gmail.com>
Subject: [GIT PULL] ACPI fix for v3.10-rc6
Date: Thu, 13 Jun 2013 20:50:21 +0200
Message-ID: <2350270.gryTXaEjHZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-3.10-rc6

to receive one ACPI fix for v3.10-rc6 which is
commit 8c9b7a7b2fc2750af418ddc28e707c42e78aa0bf

  ACPI / video: Do not bind to device objects with a scan handler

on top of commit 317ddd256b9c24b0d78fa8018f80f1e495481a10

  Linux 3.10-rc5

This is an alternative fix for the regression introduced in 3.9 whose
previous fix had to be reverted right before 3.10-rc5, because it broke
one of the Tony's machines.  In this one the check is confined to the
ACPI video driver (which is the only one causing the problem to happen
in the first place) and the Tony's box shouldn't even notice it.

Thanks!


---------------

Rafael J. Wysocki (1):
      ACPI / video: Do not bind to device objects with a scan handler

---------------

 drivers/acpi/scan.c  |    5 +----
 drivers/acpi/video.c |    3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
