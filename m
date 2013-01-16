Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3APWLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:11:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42155 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245Ab3APWLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:11:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.8-rc4
Date: Wed, 16 Jan 2013 23:16:55 +0100
Message-ID: <1747840.rmW3APh7MT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-for-3.8-rc4

to receive ACPI and power management fixes for v3.8-rc4 with top-most commit
8aef33a7cf40ca9da188e8578b2abe7267a38c52

  cpuidle: remove the power_specified field in the driver

on top of commit 9931faca02c604c22335f5a935a501bb2ace6e20

  Linux 3.8-rc3

Included are:

* cpuidle regression fix related to the initialization of state kobjects
  from Krzysztof Mazur.

* cpuidle fix removing some not very useful code and making some user-visible
  problems go away at the same time.  From Daniel Lezcano.

* ACPI build fix from Yinghai Lu.

Thanks!


 drivers/acpi/glue.c              |  2 +-
 drivers/cpuidle/cpuidle.c        | 17 ++++-------------
 drivers/cpuidle/driver.c         | 25 -------------------------
 drivers/cpuidle/governors/menu.c |  8 ++------
 drivers/cpuidle/sysfs.c          |  2 +-
 include/linux/cpuidle.h          |  2 +-
 6 files changed, 9 insertions(+), 47 deletions(-)

---------------

Daniel Lezcano (1):
      cpuidle: remove the power_specified field in the driver

Krzysztof Mazur (1):
      cpuidle: fix number of initialized/destroyed states

Yinghai Lu (1):
      ACPI / glue: Fix build with ACPI_GLUE_DEBUG set


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
