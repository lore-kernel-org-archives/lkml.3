Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaIHCMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:12:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46813 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaIHCMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:12:30 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET percpu/for-3.18] percpu-refcount: several improvements
Date: Mon,  8 Sep 2014 11:12:19 +0900
Message-Id: <1410142342-8185-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset includes the following three patches improving
percpu-refcount.

 0001-percpu-refcount-improve-WARN-messages.patch
 0002-percpu-refcount-implement-percpu_ref_set_killed.patch
 0003-percpu-refcount-make-percpu_ref-based-on-longs-inste.patch

The patchset is on top of percpu/for-3.18 a34375ef9e65
("percpu-refcount: add @gfp to percpu_ref_init()") and also available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-percpu_ref-improvements

diffstat follows.  Thanks.

 include/linux/percpu-refcount.h |   25 +++++++++++----------
 lib/percpu-refcount.c           |   47 +++++++++++++++++++++++++++-------------
 2 files changed, 45 insertions(+), 27 deletions(-)

--
tejun
