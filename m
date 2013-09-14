Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3INJmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 05:42:10 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58021 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3INJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 05:42:08 -0400
MIME-Version: 1.0
Date: Sat, 14 Sep 2013 17:42:07 +0800
Message-ID: <CAF0htA5QzKiodZyG-mE3mgMHHDkVDz=_D8oW3Gd03NEUrY67MA@mail.gmail.com>
Subject: [GIT PULL] S+core Architecture : fix bugs for compiling and support
 necessary functions
From: Lennox Wu <lennox.wu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: liqin.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull these updates for S+core architecture. These updates include
updating information of maintainers, fix some trivial errors, and add
a necessary function for supporting ipv6.

The following changes since commit bdbdfdef5766c2a60185e946df242f1bc0d37c09

Merge tag 'hwmon-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
(Fri Sep 13 10:58:41 2013 -0700)

on

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git


For you to fetch changes up to 969f99168b9dff2f6cc07cdf14255178d4397c4f

git@github.com:sctscore/official-linux.git tags/branch-linus-20130914

Best,
Lennox Wu

-----------------------------------------------
Summary these commits:
1. Fix some trivial errors for successfully compiling the latest
version Linux kernel.
2. Provide necessary function for support IPV6.
3. Update the information of maintainers.
------------------------------------------------
Lennox Wu (8):
score : Update the information of Score maintainers
score : Implement the function csum_ipv6_magic
score : arch/score/kernel/entry.S: fix wrong instructions
score : arch/score/kernel/process.c : fix some typos
score : Modify the MAKEFILE of Score

 MAINTAINERS                       |    4 +-
 arch/score/Kconfig                |    4 ++
 arch/score/Makefile               |    4 +-
 arch/score/include/asm/checksum.h |   93 ++++++++++++++++++++-----------------
 arch/score/include/asm/io.h       |    1 -
 arch/score/include/asm/pgalloc.h  |    2 +-
 arch/score/kernel/entry.S         |    4 +-
 arch/score/kernel/process.c       |    4 +-
 8 files changed, 64 insertions(+), 52 deletions(-)
