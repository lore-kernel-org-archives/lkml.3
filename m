Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaJMO0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaJMO0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:26:10 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH 0/1] watchdog: parameters to control hard and soft lockup detector individually
Date: Mon, 13 Oct 2014 16:32:41 +0200
Message-Id: <1413210762-4532-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This post follows up to https://lkml.org/lkml/2014/8/11/329.
During the discussion of that patch, Ingo Molnar commented in
https://lkml.org/lkml/2014/8/18/577.

 "The softlockup and hardlockup detection control variables 
  should be in separate flags, inside and outside the kernel - 
  they (should) not relate to each other."

Please refer to [PATCH 1/1] for a description of the proposed
changes of the 'user interface' in /proc/sys/kernel and kernel
command line parameters.

Ulrich Obergfell (1):
  watchdog: parameters to control hard and soft lockup detector
    individually

 include/linux/nmi.h |  12 ++-
 kernel/sysctl.c     |  21 ++++-
 kernel/watchdog.c   | 250 +++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 236 insertions(+), 47 deletions(-)

-- 
1.7.11.7

