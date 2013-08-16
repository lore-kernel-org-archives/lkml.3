Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3HPNmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:42:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45432 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3HPNms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:42:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] Power management fix for v3.11-rc6
Date: Fri, 16 Aug 2013 15:53:17 +0200
Message-ID: <4954983.4OnybMElUM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-3.11-rc6

to receive one power management fix for v3.11-rc6 as
commit 40fea92ffb5fa0ef26d10ae0fe5688bc8e61c791

  PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()

on top of commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8

  Linux 3.11-rc5

This fixes a deadlock introduced by the removal of delayed_work_pending()
checks from kernel/power/qos.c in 3.9, so it is stable material.

Thanks!


---------------

Stephen Boyd (1):
      PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()

---------------

 kernel/power/qos.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

