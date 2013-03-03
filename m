Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3CCByU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:54:20 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:38514 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 00/14] MAINTAINERS: fix file patterns (part 2)
Date: Sat,  2 Mar 2013 22:53:38 -0300
Message-Id: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series attempts to fix the remaining F: patterns on the
MAINTAINERS file which point to non-existing files or directories.

Several more problems with the F: patterns appeared since the previous
patch series was sent. This patch series fixes all of them, except for
the removal of drivers/rtc/rtc-sec.c (which was NAKed). It also has a
copy of the single patch from the previous series which was not applied
(fix BAST).

Patch 12 also attempts to add matching uapi/ patterns to all include
directory patterns where this was not yet done, if applicable.

The last two patches in this series are optional. They add the small
script which I used to find the broken patterns, and change one pattern
to avoid a false positive from the script.

Cesar Eduardo Barros (14):
  MAINTAINERS: remove 3c505
  MAINTAINERS: remove arch/arm/plat-nomadik/
  MAINTAINERS: remove arch/arm/plat-s3c24xx/
  MAINTAINERS: fix drivers/media/i2c/cx2341x.c
  MAINTAINERS: remove drivers/net/wan/cycx*
  MAINTAINERS: fix drivers/edac/ghes-edac.c
  MAINTAINERS: remove eexpress
  MAINTAINERS: fix mach-omap2 clockdomain/powerdomain
  MAINTAINERS: fix Documentation/video4linux/saa7134/
  MAINTAINERS: remove include/media/sh_veu.h
  MAINTAINERS: fix BAST
  MAINTAINERS: adjust for UAPI (part 2)
  scripts: add checkmaintainers.py
  MAINTAINERS: use same pattern for firewire in uapi

 MAINTAINERS                 | 69 ++++++++++++++++++++++++---------------------
 scripts/checkmaintainers.py | 35 +++++++++++++++++++++++
 2 files changed, 72 insertions(+), 32 deletions(-)
 create mode 100755 scripts/checkmaintainers.py

-- 
1.7.11.7

