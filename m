Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaJGAVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:21:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48430 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaJGAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:21:49 -0400
Message-Id: <cover.1412640584.git.geoff@infradead.org>
In-Reply-To: <cover.1408731991.git.geoff@infradead.org>
References: <cover.1408731991.git.geoff@infradead.org>
From: Geoff Levand <geoff@infradead.org>
Patch-Date: Mon, 6 Oct 2014 17:09:44 -0700
Subject: [PATCH V2 0/5] kexec: Minor fixups and enhancements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 00:21:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This series is basically a re-send of my kexec fix-up patches I sent out back
in August.  Everyone who commented seemed to think these changes were OK, but
there doesn't seem to be a kexec maintainer to pick these up.  Could you take
them through your mm tree?

Please let us know.

-Geoff

V2 changes:
	o Collected various Acked-by's.

The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

  git://git.linaro.org/people/geoff.levand/linux-kexec.git for-kexec

for you to fetch changes up to adf97d602657c72f6ee59aefe5d51149159a3e99:

  powerpc/kexec: Use global IND_FLAGS macro (2014-10-06 17:06:26 -0700)

----------------------------------------------------------------
Geoff Levand (5):
      kexec: Fix make headers_check
      kexec: Simplify conditional
      kexec: Add bit definitions for kimage entry flags
      kexec: Add IND_FLAGS macro
      powerpc/kexec: Use global IND_FLAGS macro

 arch/powerpc/kernel/machine_kexec_64.c |  2 --
 include/linux/kexec.h                  | 20 ++++++++++++++++----
 include/uapi/linux/kexec.h             |  6 ------
 kernel/kexec.c                         | 17 ++++++++++-------
 4 files changed, 26 insertions(+), 19 deletions(-)

-- 
1.9.1

