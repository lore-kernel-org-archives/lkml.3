Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3AVLoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:44:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3AVLoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:44:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628475"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH Bug fix 5/5] Bug fix: Fix the doc format in drivers/firmware/memmap.c
Date: Tue, 22 Jan 2013 19:43:04 +0800
Message-Id: <1358854984-6073-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:42:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:43:02,
	Serialize complete at 2013/01/22 19:43:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comments in drivers/firmware/memmap.c kernel-doc compliant.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/firmware/memmap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 658fdd4..0b5b5f6 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -209,7 +209,7 @@ static inline void remove_sysfs_fw_map_entry(struct firmware_map_entry *entry)
 }
 
 /*
- * firmware_map_find_entry_in_list: Search memmap entry in a given list.
+ * firmware_map_find_entry_in_list() - Search memmap entry in a given list.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -219,7 +219,7 @@ static inline void remove_sysfs_fw_map_entry(struct firmware_map_entry *entry)
  * given list. The caller must hold map_entries_lock, and must not release
  * the lock until the processing of the returned entry has completed.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
@@ -237,7 +237,7 @@ firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
 }
 
 /*
- * firmware_map_find_entry: Search memmap entry in map_entries.
+ * firmware_map_find_entry() - Search memmap entry in map_entries.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -246,7 +246,7 @@ firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
  * The caller must hold map_entries_lock, and must not release the lock
  * until the processing of the returned entry has completed.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry(u64 start, u64 end, const char *type)
@@ -255,7 +255,7 @@ firmware_map_find_entry(u64 start, u64 end, const char *type)
 }
 
 /*
- * firmware_map_find_entry_bootmem: Search memmap entry in map_entries_bootmem.
+ * firmware_map_find_entry_bootmem() - Search memmap entry in map_entries_bootmem.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -263,7 +263,7 @@ firmware_map_find_entry(u64 start, u64 end, const char *type)
  * This function is similar to firmware_map_find_entry except that it find the
  * given entry in map_entries_bootmem.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry_bootmem(u64 start, u64 end, const char *type)
-- 
1.7.1

