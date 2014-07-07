Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaGGQ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:26:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGQ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:26:24 -0400
Message-ID: <53BACA23.9010907@oracle.com>
Date: Mon, 07 Jul 2014 12:26:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "S. Lockwood-Childs" <sjl@dent.vctlabs.com>,
        zhangdianfang <zhangdianfang@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2] liblockdep fixes for v3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes

for you to fetch changes up to b10827814e9c81c5a14fb73c5a6e06bd85df3f94:

  tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire (2014-07-07 12:20:16 -0400)

----------------------------------------------------------------
S. Lockwood-Childs (1):
      tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire

Sasha Levin (1):
      tools/liblockdep: Remove debug print left over from development

zhangdianfang (1):
      tools/liblockdep: Fix comparison of a boolean value with a value of 2

 tools/lib/lockdep/include/liblockdep/mutex.h  |  4 ++--
 tools/lib/lockdep/include/liblockdep/rwlock.h |  8 ++++----
 tools/lib/lockdep/preload.c                   | 20 +++++++++-----------
 3 files changed, 15 insertions(+), 17 deletions(-)
