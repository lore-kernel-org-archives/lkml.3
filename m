Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3GEIsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:48:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50486 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3GEIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:46:51 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-93-51d687f9414c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
Date: Fri, 05 Jul 2013 17:46:36 +0900
Message-id: <1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkSPdn+7VAgzmHjC2eNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DK6Nl9ga2gU71iUuc/9gbG1QpdjJwcEgImEr9W/GOBsMUkLtxbz9bF
	yMUhJLCUUeLZ632sMEVbFuxggUgsYpQ4tPYYG0hCSOA/o8SkbYUgNpuAlsT+FzfA4iICbhJr
	r31iBGlgFmhmlDj8aSojSEJYwF6i591TMJtFQFVi48+LYBt4BVwlLr9cxwaxTU7iw55H7F2M
	HBycQIO2TCyG2OUq8evOBLAjJAQWsUtMP/qbBWKOgMS3yYdYQOolBGQlNh1ghhgjKXFwxQ2W
	CYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIEBvnpf896dzDePmB9iDEZaNxEZinR
	5HxglOSVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbHJgcP48LusxX/1faWEvgosKXPYfCVwpdP+w5vvdM1baCDO+YrXUeny5eQLs64fln6l+aF2
	uziD5foeRWuJJaw2VyOK3nX8c7qg8I1nxw+FJ8VST0MP1Kuxh/S//7il51Qdv376XpdU0SVp
	bfpXpJJcWM9vuL7s6gzLI+IMEhdmhp2WPaMsoqjEUpyRaKjFXFScCAASxLc2iAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd2f7dcCDZ4d0rJ42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bP7gtsBZ3qFZM6/7E3MK5W
	6GLk5JAQMJHYsmAHC4QtJnHh3nq2LkYuDiGBRYwSh9YeYwNJCAn8Z5SYtK0QxGYT0JLY/+IG
	WFxEwE1i7bVPjCANzALNjBKHP01lBEkIC9hL9Lx7CmazCKhKbPx5kRXE5hVwlbj8ch0bxDY5
	iQ97HrF3MXJwcAIN2jKxGGKXq8SvOxNYJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHEPPpHYwrmywOMQowMGoxMNr0XQ1UIg1say4MvcQowQHs5IIr33CtUAh3pTEyqrUovz4
	otKc1OJDjMlAR01klhJNzgfGd15JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1ML
	UotgtjBxcEo1MC4Vc1jYe93LWEB4dcH2KZ+mN3eZFO3LXbZ+V/T6b3adjz0esk85H8Bpwj/P
	Ykvqhwt3+29+N5Vbd8N4g6H/ZCOWUrMr9WId9+TWb3x896hT0fH3F19aTXPR1Z1+5n72/+T6
	v/cZeUuyF/M8XlrqNvtsCfe8Hfq+/BH8OqHTq/YU3Zp2g29izhYlluKMREMt5qLiRABy+rZK
	5QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch create debugfs root directory and child directory according to
the number of CPUs for CPUFreq as below debugfs directory path:
- /sys/kernel/debug/cpufreq/cpuX

If many CPUs share only one cpufreq policy, other CPU(except for CPU0) create
a link for debugfs directory of CPU0.
- /sys/kernel/debug/cpufreq/cpu0
- /sys/kernel/debug/cpufreq/cpu[1-(N-1)] -> /sys/kernel/debug/cpufreq/cpu0

And then cpufreq may need to create debugfs specific file below of debugfs
directory of cpufreq. (e.g., /sys/kernel/debug/cpufreq/cpu0/load_table)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/cpufreq.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  1 +
 2 files changed, 58 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..bc01c8e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -23,6 +23,7 @@
 #include <linux/notifier.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -47,6 +48,10 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 
+/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
+#define MAX_DEBUGFS_NAME_LEN	CPUFREQ_NAME_LEN
+static struct dentry *cpufreq_debugfs;
+
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
  * all cpufreq/hotplug/workqueue/etc related lock issues.
@@ -726,6 +731,20 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 			cpufreq_cpu_put(managed_policy);
 			return ret;
 		}
+
+		if (cpufreq_debugfs) {
+			char symlink_name[MAX_DEBUGFS_NAME_LEN];
+			char target_name[MAX_DEBUGFS_NAME_LEN];
+
+			sprintf(symlink_name, "cpu%d", j);
+			sprintf(target_name, "./cpu%d", cpu);
+			managed_policy->cpu_debugfs[j] = debugfs_create_symlink(
+							symlink_name,
+							cpufreq_debugfs,
+							target_name);
+			if (!managed_policy->cpu_debugfs[j])
+				pr_debug("creating debugfs symlink failed\n");
+		}
 	}
 	return ret;
 }
@@ -746,6 +765,22 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	if (ret)
 		return ret;
 
+	/* prepare interface data for debugfs */
+	if (cpufreq_debugfs) {
+		char name[MAX_DEBUGFS_NAME_LEN];
+		int size, i;
+
+		sprintf(name, "cpu%d", policy->cpu);
+		size = sizeof(struct dentry*) * NR_CPUS;
+		i = cpu;
+
+		policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
+		policy->cpu_debugfs[i] = debugfs_create_dir(name,
+							    cpufreq_debugfs);
+		if (!policy->cpu_debugfs[i])
+			pr_debug("creating debugfs directory failed\n");
+	}
+
 	/* set up files for this cpu device */
 	drv_attr = cpufreq_driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
@@ -839,6 +874,20 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 		return ret;
 	}
 
+	if (cpufreq_debugfs) {
+		char symlink_name[MAX_DEBUGFS_NAME_LEN];
+		char target_name[MAX_DEBUGFS_NAME_LEN];
+
+		sprintf(symlink_name, "cpu%d", cpu);
+		sprintf(target_name, "./cpu%d", sibling);
+		policy->cpu_debugfs[cpu] = debugfs_create_symlink(
+						symlink_name,
+						cpufreq_debugfs,
+						target_name);
+		if (!policy->cpu_debugfs[cpu])
+			pr_debug("creating debugfs symlink failed\n");
+	}
+
 	return 0;
 }
 #endif
@@ -1046,6 +1095,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	if (cpu != data->cpu) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
+		debugfs_remove(data->cpu_debugfs[cpu]);
 	} else if (cpus > 1) {
 		/* first sibling now owns the new sysfs dir */
 		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
@@ -1068,6 +1118,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			return -EINVAL;
 		}
 
+		debugfs_remove_recursive(data->cpu_debugfs[cpu]);
+		debugfs_remove(cpufreq_debugfs);
+
 		WARN_ON(lock_policy_rwsem_write(cpu));
 		update_policy_cpu(data, cpu_dev->id);
 		unlock_policy_rwsem_write(cpu);
@@ -1976,6 +2029,10 @@ static int __init cpufreq_core_init(void)
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);
 
+	cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
+	if (!cpufreq_debugfs)
+		pr_debug("creating debugfs root failed\n");
+
 	return 0;
 }
 core_initcall(cpufreq_core_init);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..825f379 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -115,6 +115,7 @@ struct cpufreq_policy {
 
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+	struct dentry		**cpu_debugfs;
 };
 
 #define CPUFREQ_ADJUST			(0)
-- 
1.8.0

