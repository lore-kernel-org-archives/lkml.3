Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaL0Urr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:47:47 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46148 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaL0Urq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:47:46 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 0/5] staging: lustre: selftest: fix various sparse warnings
Date: Sat, 27 Dec 2014 12:46:45 -0800
Message-Id: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix most of the "undeclared" and "context imbalance"
sparse warnings for the lustre code in the selftest/ directory.

Jeremiah Mahler (5):
  staging: lustre: selftest: fix "not declared" by declaring in header
  staging: lustre: selftest: fix "not declared" by declaring static
  staging: lustre: selftest: fix sfw_deactivate_session context
    imbalance
  staging: lustre: selftest: fix _post_buffer context imbalance
  staging: lustre: selftest: fix _recycle_buffer context imbalance

 drivers/staging/lustre/lnet/selftest/framework.c |  4 ++--
 drivers/staging/lustre/lnet/selftest/rpc.c       |  4 +++-
 drivers/staging/lustre/lnet/selftest/selftest.h  | 12 ++++++++++++
 drivers/staging/lustre/lnet/selftest/timer.c     |  2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.1.4

