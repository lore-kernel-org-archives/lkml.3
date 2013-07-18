Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab3GRLSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:18:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17935 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab3GRLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:18:05 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-d6-51e7ceeb1798
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
Date: Thu, 18 Jul 2013 20:17:53 +0900
Message-id: <1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkWPf1ueeBBnOnGFk8bfrBbnH9y3NW
	i7NNb9gtLu+aw2bxufcIo8XtxhVsFv0Le5ksNn71cODwuHNtD5tH35ZVjB6PFrcwenzeJBfA
	EsVlk5Kak1mWWqRvl8CV0b2kjb3gpHvFom3P2BoYW627GDk5JARMJA7OaGKFsMUkLtxbzwZi
	CwksZZTYejkUpmbt3c1ANVxA8UWMEvubzzJDOI1MErPXHwfrYBPQktj/4gaYLSLgJrH22idG
	kCJmgSmMEs3HNoElhAWcJL6v+scEYrMIqEqsWbqOBcTmFXCR+L3yD9QZchIf9jxiB7E5BVwl
	Nn05AHWSi8SFU/1sIEMlBKazSzz8txhqkIDEt8mHgAZxACVkJTYdYIaYIylxcMUNlgmMwgsY
	GVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBIb56X/PJuxgvHfA+hBjMtC4icxSosn5wDjJ
	K4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjf8st
	yarGGCOL9P8Z/dd71xraHxNZYbD+1tcpJz74p3bMyDs5WfdGpeO8kJKTU1Y9ve10a1HAvX/d
	biwHV1wxObQx75VraKnd/rl1EgnH1C7+9L4humR+4H9198QPt2wKNLZ9O/3vS5S//czr4u/K
	su0kvt2QmnJNcc8M71+9R1a8SzDY+nVKohJLcUaioRZzUXEiAE6e722JAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd3X554HGhw8pmHxtOkHu8X1L89Z
	Lc42vWG3uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwefVtWMXo8WtzC6PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozuJW3sBSfdKxZte8bWwNhq
	3cXIySEhYCKx9u5mVghbTOLCvfVsXYxcHEICixgl9jefZYZwGpkkZq8/zgZSxSagJbH/xQ0w
	W0TATWLttU+MIEXMAlMYJZqPbQJLCAs4SXxf9Y8JxGYRUJVYs3QdC4jNK+Ai8XvlH6h1chIf
	9jxiB7E5BVwlNn05ANYrBFRz4VQ/2wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcx
	guPomdQOxpUNFocYBTgYlXh4b/A8DxRiTSwrrsw9xCjBwawkwvttH1CINyWxsiq1KD++qDQn
	tfgQYzLQVROZpUST84ExnlcSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs1NSC1CKY
	LUwcnFINjNW/WBf+nFkYqrfi+4xrNndPc9zkeuLKffCuZFu93YxpXPKrDn/9Fbw/9fGPrnSV
	zaIPvyaXrgjcPuGiotxBT8GSralzViwyPzybrzyS1/q06kL/HcZlUcct53flX/AIP2a2tqNE
	3CVqt//dn2aFHdLxzEYsuqtjZ5jsmhU3Ocmq6tfVjM0lfkosxRmJhlrMRcWJAB8r8mPnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch create debugfs root directory and child directory according to
the number of CPUs for CPUFreq as below debugfs directory path:
- /sys/kernel/debug/cpufreq/cpuX

If many CPUs share only one cpufreq policy, other CPUs(except for first CPU)
create a symbolic link for debugfs directory of CPU0.
- link: /sys/kernel/debug/cpufreq/cpu[1-(N-1)] -> /sys/kernel/debug/cpufreq/cpu0

And then cpufreq may need to create debugfs specific file below of debugfs
directory of cpufreq. (e.g., /sys/kernel/debug/cpufreq/cpu0/load_table)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
Changes since v5:
- Refactoring patch v4
- Create again symbolic link of debugfs directory when first CPU dev is removed
  (In this case, many CPUs share only one cpufreq policy)

 drivers/cpufreq/cpufreq.c | 177 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |   1 +
 2 files changed, 178 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..924d654 100644
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
@@ -703,6 +704,164 @@ static struct kobj_type ktype_cpufreq = {
 	.release	= cpufreq_sysfs_release,
 };
 
+#ifdef CONFIG_CPU_FREQ_STAT
+/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
+static struct dentry *cpufreq_debugfs;
+
+static int cpufreq_create_debugfs_dir(struct cpufreq_policy *policy,
+				      struct device *dev)
+{
+	char name[CPUFREQ_NAME_LEN];
+	unsigned int cpus, size, idx;
+
+	if (!cpufreq_debugfs)
+		return -EINVAL;
+
+	cpus = cpumask_weight(policy->cpus);
+	idx = cpus > 1 ? policy->cpu : 0;
+
+	size = sizeof(struct dentry*) * cpus;
+	policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
+	if (!policy->cpu_debugfs) {
+		pr_err("allocating debugfs memory failed\n");
+		return -ENOMEM;
+	}
+
+	sprintf(name, "cpu%d", policy->cpu);
+	policy->cpu_debugfs[idx] = debugfs_create_dir(name, cpufreq_debugfs);
+	if (!policy->cpu_debugfs[idx]) {
+		pr_err("creating debugfs directory failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int cpufreq_create_debugfs_symlink(struct cpufreq_policy *policy,
+					   unsigned int src_cpu,
+					   unsigned int dest_cpu)
+{
+	char symlink_name[CPUFREQ_NAME_LEN];
+	char target_name[CPUFREQ_NAME_LEN];
+
+	if (!cpufreq_debugfs)
+		return -EINVAL;
+
+	if (!policy->cpu_debugfs[src_cpu])
+		return -EINVAL;
+
+	sprintf(symlink_name, "cpu%d", dest_cpu);
+	sprintf(target_name, "./cpu%d", src_cpu);
+	policy->cpu_debugfs[dest_cpu] = debugfs_create_symlink(
+					symlink_name,
+					cpufreq_debugfs,
+					target_name);
+	if (!policy->cpu_debugfs[dest_cpu]) {
+		pr_err("creating debugfs symlink failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
+				       unsigned int cpu)
+{
+	unsigned int idx = cpumask_weight(policy->cpus) > 1 ? cpu : 0;
+
+	if (!policy->cpu_debugfs[idx])
+		return;
+
+	debugfs_remove_recursive(policy->cpu_debugfs[idx]);
+}
+
+static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
+				     unsigned int new_cpu)
+{
+	struct dentry *old_entry, *new_entry;
+	char new_dir_name[CPUFREQ_NAME_LEN];
+	unsigned int j, old_cpu = policy->cpu;
+
+	if (!policy->cpu_debugfs[new_cpu])
+		return;
+
+	/*
+	 * Remove symbolic link of debugfs directory except for debugfs
+	 * directory of old_cpu.
+	 */
+	for_each_present_cpu(j) {
+		if (old_cpu == j)
+			continue;
+
+		debugfs_remove(policy->cpu_debugfs[j]);
+	}
+
+	/*
+	 * Change debugfs directory name from as following:
+	 * - old debugfs dir name : /sys/kernel/debugfs/cpufreq/cpu${old_cpu}
+	 * - new debugfs dir name : /sys/kernel/debugfs/cpufreq/cpu${new_cpu}
+	 */
+	sprintf(new_dir_name, "cpu%d", new_cpu);
+	old_entry = policy->cpu_debugfs[old_cpu];
+	new_entry = debugfs_rename(cpufreq_debugfs, old_entry,
+				   cpufreq_debugfs, new_dir_name);
+	if (!new_entry) {
+		pr_err("changing debugfs directory name failed\n");
+		goto err_rename;
+	}
+
+	policy->cpu_debugfs[new_cpu] = new_entry;
+	policy->cpu_debugfs[old_cpu] = NULL;
+
+	/* Create again symbolic link of debugfs directory */
+	for_each_present_cpu(j) {
+		if (new_cpu == j)
+			continue;
+
+		cpufreq_create_debugfs_symlink(policy, new_cpu, j);
+	}
+
+	return;
+
+err_rename:
+	for_each_present_cpu(j) {
+		if (old_cpu == j)
+			continue;
+
+		cpufreq_create_debugfs_symlink(policy, old_cpu, j);
+	}
+}
+
+static int cpufreq_create_debugfs(void)
+{
+	cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
+	if (!cpufreq_debugfs) {
+		pr_err("creating debugfs root failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void cpufreq_remove_debugfs(void)
+{
+	if (cpufreq_debugfs)
+		debugfs_remove_recursive(cpufreq_debugfs);
+}
+#else
+static int cpufreq_create_debugfs_dir(struct cpufreq_policy *policy,
+					struct device *dev) { return 0; }
+static int cpufreq_create_debugfs_symlink(struct cpufreq_policy *policy,
+					unsigned int src_cpu,
+					unsigned int dest_cpu) { return 0;}
+static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
+					unsigned int cpu) { }
+static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
+					unsigned int new_cpu) { }
+static int cpufreq_create_debugfs(void) { return 0; }
+static void cpufreq_remove_debugfs(void) { }
+#endif
+
 /* symlink affected CPUs */
 static int cpufreq_add_dev_symlink(unsigned int cpu,
 				   struct cpufreq_policy *policy)
@@ -726,6 +885,8 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 			cpufreq_cpu_put(managed_policy);
 			return ret;
 		}
+
+		cpufreq_create_debugfs_symlink(policy, cpu, j);
 	}
 	return ret;
 }
@@ -777,6 +938,9 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	/* prepare interface data for debugfs */
+	cpufreq_create_debugfs_dir(policy, dev);
+
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
 		goto err_out_kobj_put;
@@ -839,6 +1003,8 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 		return ret;
 	}
 
+	cpufreq_create_debugfs_symlink(policy, sibling, cpu);
+
 	return 0;
 }
 #endif
@@ -1046,6 +1212,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	if (cpu != data->cpu) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
+		cpufreq_remove_debugfs_dir(data, cpu);
 	} else if (cpus > 1) {
 		/* first sibling now owns the new sysfs dir */
 		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
@@ -1068,6 +1235,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 			return -EINVAL;
 		}
 
+		cpufreq_move_debugfs_dir(data, cpu_dev->id);
+
 		WARN_ON(lock_policy_rwsem_write(cpu));
 		update_policy_cpu(data, cpu_dev->id);
 		unlock_policy_rwsem_write(cpu);
@@ -1089,6 +1258,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		unlock_policy_rwsem_read(cpu);
 		kobject_put(kobj);
 
+		cpufreq_remove_debugfs_dir(data, cpu);
+
 		/* we need to make sure that the underlying kobj is actually
 		 * not referenced anymore by anybody before we proceed with
 		 * unloading.
@@ -1894,6 +2065,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	cpufreq_create_debugfs();
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
@@ -1918,12 +2091,14 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	}
 
 	register_hotcpu_notifier(&cpufreq_cpu_notifier);
+
 	pr_debug("driver %s up and running\n", driver_data->name);
 
 	return 0;
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
+	cpufreq_remove_debugfs();
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -1949,6 +2124,8 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 
 	pr_debug("unregistering driver %s\n", driver->name);
 
+	cpufreq_remove_debugfs();
+
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
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

