Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaHKOtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaHKOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:49:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: akpm@linux-foundation.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/5] watchdog: various fixes
Date: Mon, 11 Aug 2014 10:49:22 -0400
Message-Id: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just respinning these patches with my sign-off.  I keep forgetting which is
easier for Andrew to digest (this way or just me replying with an ack).

Ulrich Obergfell (3):
  watchdog: fix print-once on enable
  watchdog: control hard lockup detection default
  kvm: ensure hard lockup detection is disabled by default

chai wen (2):
  watchdog: remove unnecessary head files
  softlockup: make detector be aware of task switch of processes
    hogging cpu

 arch/x86/kernel/kvm.c |    8 +++++
 include/linux/nmi.h   |    9 +++++
 kernel/watchdog.c     |   78 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 86 insertions(+), 9 deletions(-)

