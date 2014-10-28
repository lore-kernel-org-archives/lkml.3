Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaJ1WeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37387 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbaJ1WeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcutorture: Remove stale test configurations
Date: Tue, 28 Oct 2014 15:30:03 -0700
Message-Id: <1414535405-30228-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0724E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Remove rcutorture configuration files which are no longer necessary.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/configs/rcu/v0.0/CFLIST   | 14 ------
 .../configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP           | 18 -------
 .../configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp           | 22 ---------
 .../configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP           | 18 -------
 .../configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp           | 22 ---------
 .../selftests/rcutorture/configs/rcu/v0.0/NT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v0.0/NT3-NH   | 20 --------
 .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           | 19 --------
 .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           | 20 --------
 .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           | 22 ---------
 .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           | 27 ----------
 .../selftests/rcutorture/configs/rcu/v0.0/PT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v0.0/PT2-NH   | 22 ---------
 .../rcutorture/configs/rcu/v0.0/ver_functions.sh   | 33 -------------
 .../selftests/rcutorture/configs/rcu/v3.12/CFLIST  | 17 -------
 .../configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP          | 19 --------
 .../configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp          | 20 --------
 .../configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp          | 22 ---------
 .../configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP          | 18 -------
 .../configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp          | 22 ---------
 .../configs/rcu/v3.12/N6---t-nh-SD-smp-hp          | 19 --------
 .../configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP          | 26 ----------
 .../configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP          | 22 ---------
 .../selftests/rcutorture/configs/rcu/v3.12/NT1-nh  | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.12/NT3-NH  | 20 --------
 .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          | 20 --------
 .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          | 20 --------
 .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          | 20 --------
 .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          | 22 ---------
 .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          | 27 ----------
 .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          | 18 -------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          | 30 ------------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      | 30 ------------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     | 30 ------------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          | 30 ------------
 .../selftests/rcutorture/configs/rcu/v3.12/PT1-nh  | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.12/PT2-NH  | 22 ---------
 .../selftests/rcutorture/configs/rcu/v3.3/CFLIST   | 14 ------
 .../configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP           | 19 --------
 .../configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp           | 22 ---------
 .../configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP           | 18 -------
 .../configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp           | 22 ---------
 .../selftests/rcutorture/configs/rcu/v3.3/NT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.3/NT3-NH   | 20 --------
 .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           | 20 --------
 .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           | 20 --------
 .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           | 22 ---------
 .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           | 27 ----------
 .../selftests/rcutorture/configs/rcu/v3.3/PT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.3/PT2-NH   | 22 ---------
 .../rcutorture/configs/rcu/v3.3/ver_functions.sh   | 44 -----------------
 .../selftests/rcutorture/configs/rcu/v3.5/CFLIST   | 14 ------
 .../configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP           | 19 --------
 .../configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp           | 22 ---------
 .../configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP           | 18 -------
 .../configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp           | 22 ---------
 .../selftests/rcutorture/configs/rcu/v3.5/NT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.5/NT3-NH   | 20 --------
 .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           | 20 --------
 .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           | 20 --------
 .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           | 20 --------
 .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           | 22 ---------
 .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           | 27 ----------
 .../selftests/rcutorture/configs/rcu/v3.5/PT1-nh   | 23 ---------
 .../selftests/rcutorture/configs/rcu/v3.5/PT2-NH   | 22 ---------
 .../rcutorture/configs/rcu/v3.5/ver_functions.sh   | 57 ----------------------
 71 files changed, 1588 deletions(-)
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d3ef873eb6e7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index f72402d7c13d..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
deleted file mode 100644
index 5ace37a89780..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
+++ /dev/null
@@ -1,33 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-# Which old kernels do not.
-per_version_boot_params () {
-	echo	rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
deleted file mode 100644
index da4cbc668f2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
+++ /dev/null
@@ -1,17 +0,0 @@
-sysidleY.2013.06.19a
-sysidleN.2013.06.19a
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-P6---t-nh-SD-smp-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
deleted file mode 100644
index 0ccc36d72738..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=1
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 3f640cf84973..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,26 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
deleted file mode 100644
index 285da2dd8ac3..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=14
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
deleted file mode 100644
index f4c9175828bf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=n
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 77a8c5b75763..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
deleted file mode 100644
index 588bc70420cd..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=y
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
deleted file mode 100644
index bae55692ce6e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
+++ /dev/null
@@ -1,44 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
deleted file mode 100644
index 8977d8d31b19..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
+++ /dev/null
@@ -1,57 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
-	then
-		:
-	else
-		echo rcutorture.n_barrier_cbs=4
-	fi
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		`rcutorture_param_n_barrier_cbs "$1"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
-- 
1.8.1.5

