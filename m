Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3EITJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:09:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41474 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab3EITJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:09:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI fixes for v3.10-rc1
Date: Thu, 09 May 2013 21:18:23 +0200
Message-ID: <1903378.croiM3Nu8S@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-fixes-3.10-rc1

to receive ACPI fixes for v3.10-rc1 with top-most commit
04a29a15520463e072b1a98d8989f04233ee4a7e

  ACPICA: ACPICA: Fix for _INI regression

on top of commit 371deb9500831ad1afbf9ea00e373f650deaed2f

  Merge branch 'pm-cpufreq'

These are three urgent ACPICA fixes two of which fix regressions introduced
earlier during this merge window and the third one fixes a potential buffer
overflow that has been there for quite a while (fortunately, it's not easy
to trigger).

Thanks!


---------------

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation

Jung-uk Kim (1):
      ACPICA: _OSI support: Fix possible memory leak

Tomasz Nowicki (1):
      ACPICA: ACPICA: Fix for _INI regression

---------------

 drivers/acpi/acpica/exfldio.c |   14 +++++++++++++-
 drivers/acpi/acpica/nsinit.c  |    1 +
 drivers/acpi/acpica/utosi.c   |    3 ++-
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
