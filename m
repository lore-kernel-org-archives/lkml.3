Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaHTOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:10:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaHTOKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:10:54 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Make scripts executable
Date: Wed, 20 Aug 2014 16:10:48 +0200
Message-Id: <1408543848-24977-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefiles call the respective interpreter explicitly, but this makes
it easier to use the scripts manually.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/bootgraph.pl                       | 0
 scripts/export_report.pl                   | 0
 scripts/gcc-goto.sh                        | 0
 scripts/gcc-ld                             | 0
 scripts/gcc-version.sh                     | 0
 scripts/gcc-x86_32-has-stack-protector.sh  | 0
 scripts/gcc-x86_64-has-stack-protector.sh  | 0
 scripts/gen_initramfs_list.sh              | 0
 scripts/headers_check.pl                   | 0
 scripts/headers_install.sh                 | 0
 scripts/kconfig/lxdialog/check-lxdialog.sh | 0
 scripts/kconfig/streamline_config.pl       | 0
 scripts/link-vmlinux.sh                    | 0
 scripts/markup_oops.pl                     | 0
 scripts/mkmakefile                         | 0
 scripts/mksysmap                           | 0
 scripts/package/builddeb                   | 0
 scripts/package/buildtar                   | 0
 scripts/profile2linkerlist.pl              | 0
 scripts/rt-tester/rt-tester.py             | 0
 scripts/selinux/install_policy.sh          | 0
 scripts/tracing/draw_functrace.py          | 0
 scripts/xz_wrap.sh                         | 0
 23 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 scripts/bootgraph.pl
 mode change 100644 => 100755 scripts/export_report.pl
 mode change 100644 => 100755 scripts/gcc-goto.sh
 mode change 100644 => 100755 scripts/gcc-ld
 mode change 100644 => 100755 scripts/gcc-version.sh
 mode change 100644 => 100755 scripts/gcc-x86_32-has-stack-protector.sh
 mode change 100644 => 100755 scripts/gcc-x86_64-has-stack-protector.sh
 mode change 100644 => 100755 scripts/gen_initramfs_list.sh
 mode change 100644 => 100755 scripts/headers_check.pl
 mode change 100644 => 100755 scripts/headers_install.sh
 mode change 100644 => 100755 scripts/kconfig/lxdialog/check-lxdialog.sh
 mode change 100644 => 100755 scripts/kconfig/streamline_config.pl
 mode change 100644 => 100755 scripts/link-vmlinux.sh
 mode change 100644 => 100755 scripts/markup_oops.pl
 mode change 100644 => 100755 scripts/mkmakefile
 mode change 100644 => 100755 scripts/mksysmap
 mode change 100644 => 100755 scripts/package/builddeb
 mode change 100644 => 100755 scripts/package/buildtar
 mode change 100644 => 100755 scripts/profile2linkerlist.pl
 mode change 100644 => 100755 scripts/rt-tester/rt-tester.py
 mode change 100644 => 100755 scripts/selinux/install_policy.sh
 mode change 100644 => 100755 scripts/tracing/draw_functrace.py
 mode change 100644 => 100755 scripts/xz_wrap.sh

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
old mode 100644
new mode 100755
diff --git a/scripts/export_report.pl b/scripts/export_report.pl
old mode 100644
new mode 100755
diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
old mode 100644
new mode 100755
diff --git a/scripts/gcc-ld b/scripts/gcc-ld
old mode 100644
new mode 100755
diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
old mode 100644
new mode 100755
diff --git a/scripts/gcc-x86_32-has-stack-protector.sh b/scripts/gcc-x86_32-has-stack-protector.sh
old mode 100644
new mode 100755
diff --git a/scripts/gcc-x86_64-has-stack-protector.sh b/scripts/gcc-x86_64-has-stack-protector.sh
old mode 100644
new mode 100755
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
old mode 100644
new mode 100755
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
old mode 100644
new mode 100755
diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
old mode 100644
new mode 100755
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
old mode 100644
new mode 100755
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
old mode 100644
new mode 100755
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
old mode 100644
new mode 100755
diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
old mode 100644
new mode 100755
diff --git a/scripts/mkmakefile b/scripts/mkmakefile
old mode 100644
new mode 100755
diff --git a/scripts/mksysmap b/scripts/mksysmap
old mode 100644
new mode 100755
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
old mode 100644
new mode 100755
diff --git a/scripts/package/buildtar b/scripts/package/buildtar
old mode 100644
new mode 100755
diff --git a/scripts/profile2linkerlist.pl b/scripts/profile2linkerlist.pl
old mode 100644
new mode 100755
diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
old mode 100644
new mode 100755
diff --git a/scripts/selinux/install_policy.sh b/scripts/selinux/install_policy.sh
old mode 100644
new mode 100755
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
old mode 100644
new mode 100755
diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
old mode 100644
new mode 100755
-- 
1.8.4.5

