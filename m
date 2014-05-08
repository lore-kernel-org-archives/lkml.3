Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaEHSEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:04:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35230 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaEHSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:04:24 -0400
Message-ID: <536BC719.3060206@oracle.com>
Date: Thu, 08 May 2014 14:04:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "S. Lockwood-Childs" <sjl@dent.vctlabs.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] liblockdep fixes for v3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes-3.15

for you to fetch changes up to ad3b564deb91c67ff9621255307ed31da870c8f7:

  tools/liblockdep: Remove all build files when doing make clean (2014-05-08 13:55:13 -0400)

----------------------------------------------------------------
S. Lockwood-Childs (1):
      tools/liblockdep: Build liblockdep from tools/Makefile

Sasha Levin (1):
      tools/liblockdep: Remove all build files when doing make clean

 tools/Makefile             | 6 ++++++
 tools/lib/lockdep/Makefile | 5 ++---
 2 files changed, 8 insertions(+), 3 deletions(-)
