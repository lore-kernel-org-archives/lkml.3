Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaDWFZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:25:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61342 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaDWFZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:25:41 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-9c-53574ed38310
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: clean up long variable names
Date: Wed, 23 Apr 2014 14:23:30 +0900
Message-id: <1398230612-7062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ93LfuHBBod3q1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH76k3GglVOFU1N
	HewNjFtNuxg5OSQETCT+Nm9mhbDFJC7cW8/WxcjFISSwjFFi+9IdbDBFF+4vYoRILGKUmHH/
	MxOE08kkcX72HqAMBwebgLbE5v0GIA0iAswSC6aeB2tgFpjAKPF/0XsWkISwgLnE5mlvmEFs
	FgFViX3z7jCB2LwCbhKzFh9ngdimLbHt+URGCPs+m8SsjjCIegGJb5MPsYDskhCQldh0gBmi
	RFLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECAnB3h2Mtw9YH2JMBho3
	kVlKNDkfGMJ5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cCoqGWzQeb8YiGnc72ilZfDT97983HGL8mCX+dfxykwhx1L42bueGkc7ydza4fZ4iVz
	m9x1FMWDzBwybnzqbPZatWTavcUTvXz6xTtkz1ce/7NkDXfHxKKZXGVCNhd7zqfr8N2Ic9ua
	qyg570PC5Z2PXsRrb/jCmiFaG1+Vn7vtuHwJk/jcyc+VWIozEg21mIuKEwECzy2qVwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd3LfuHBBrc3yVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx++pNxoJVThVNTR3sDYxbTbsYOTkkBEwkLtxfxAhhi0lcuLeerYuRi0NI
	YBGjxIz7n5kgnE4mifOz9wBVcXCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAuY
	S2ye9oYZxGYRUJXYN+8OE4jNK+AmMWvxcRaIbdoS255PZJzAyL2AkWEVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnCIP5PawbiyweIQowAHoxIPb8HKsGAh1sSy4srcQ4wSHMxKIrwzPwKF
	eFMSK6tSi/Lji0pzUosPMSYDbZ/ILCWanA+Mv7ySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYFz3OOPQFy4D/61Wz+8Wz5Lyr7Hu5+K542hvNVEyqWHRjOrT
	jl0Ki+a/bJ7q5b31U8r6RVvc0pKEvGc3vXkkrtjtEyfJn75w+Qz7b/76G0oTl4cI7rgWz/C7
	mX+pT0T7fPbs0jW871dsVmlmau6csU1y7U3emM1rnwt9FyxzePt9WVWa50OtEiWW4oxEQy3m
	ouJEAHB10hK1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes simple clean-ups to reduce unnecessary long variable names.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/xattr.c | 86 +++++++++++++++++++++++++++++----------------------------
 fs/f2fs/xattr.h |  6 ++--
 2 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 503c245..1de057d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -26,7 +26,7 @@
 #include "xattr.h"
 
 static size_t f2fs_xattr_generic_list(struct dentry *dentry, char *list,
-		size_t list_size, const char *name, size_t name_len, int type)
+		size_t list_size, const char *name, size_t len, int type)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
 	int total_len, prefix_len = 0;
@@ -53,11 +53,11 @@ static size_t f2fs_xattr_generic_list(struct dentry *dentry, char *list,
 		return -EINVAL;
 	}
 
-	total_len = prefix_len + name_len + 1;
+	total_len = prefix_len + len + 1;
 	if (list && total_len <= list_size) {
 		memcpy(list, prefix, prefix_len);
-		memcpy(list + prefix_len, name, name_len);
-		list[prefix_len + name_len] = '\0';
+		memcpy(list + prefix_len, name, len);
+		list[prefix_len + len] = '\0';
 	}
 	return total_len;
 }
@@ -112,7 +112,7 @@ static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
 }
 
 static size_t f2fs_xattr_advise_list(struct dentry *dentry, char *list,
-		size_t list_size, const char *name, size_t name_len, int type)
+		size_t list_size, const char *name, size_t len, int type)
 {
 	const char *xname = F2FS_SYSTEM_ADVISE_PREFIX;
 	size_t size;
@@ -155,9 +155,10 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
 }
 
 #ifdef CONFIG_F2FS_FS_SECURITY
-static int __f2fs_setxattr(struct inode *inode, int name_index,
-			const char *name, const void *value, size_t value_len,
+static int __f2fs_setxattr(struct inode *inode, int index,
+			const char *name, const void *value, size_t size,
 			struct page *ipage);
+
 static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		void *page)
 {
@@ -241,26 +242,26 @@ const struct xattr_handler *f2fs_xattr_handlers[] = {
 	NULL,
 };
 
-static inline const struct xattr_handler *f2fs_xattr_handler(int name_index)
+static inline const struct xattr_handler *f2fs_xattr_handler(int index)
 {
 	const struct xattr_handler *handler = NULL;
 
-	if (name_index > 0 && name_index < ARRAY_SIZE(f2fs_xattr_handler_map))
-		handler = f2fs_xattr_handler_map[name_index];
+	if (index > 0 && index < ARRAY_SIZE(f2fs_xattr_handler_map))
+		handler = f2fs_xattr_handler_map[index];
 	return handler;
 }
 
-static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int name_index,
-					size_t name_len, const char *name)
+static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int index,
+					size_t len, const char *name)
 {
 	struct f2fs_xattr_entry *entry;
 
 	list_for_each_xattr(entry, base_addr) {
-		if (entry->e_name_index != name_index)
+		if (entry->e_name_index != index)
 			continue;
-		if (entry->e_name_len != name_len)
+		if (entry->e_name_len != len)
 			continue;
-		if (!memcmp(entry->e_name, name, name_len))
+		if (!memcmp(entry->e_name, name, len))
 			break;
 	}
 	return entry;
@@ -396,42 +397,43 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 	return 0;
 }
 
-int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
+int f2fs_getxattr(struct inode *inode, int index, const char *name,
 		void *buffer, size_t buffer_size)
 {
 	struct f2fs_xattr_entry *entry;
 	void *base_addr;
 	int error = 0;
-	size_t value_len, name_len;
+	size_t size, len;
 
 	if (name == NULL)
 		return -EINVAL;
-	name_len = strlen(name);
-	if (name_len > F2FS_NAME_LEN)
+
+	len = strlen(name);
+	if (len > F2FS_NAME_LEN)
 		return -ERANGE;
 
 	base_addr = read_all_xattrs(inode, NULL);
 	if (!base_addr)
 		return -ENOMEM;
 
-	entry = __find_xattr(base_addr, name_index, name_len, name);
+	entry = __find_xattr(base_addr, index, len, name);
 	if (IS_XATTR_LAST_ENTRY(entry)) {
 		error = -ENODATA;
 		goto cleanup;
 	}
 
-	value_len = le16_to_cpu(entry->e_value_size);
+	size = le16_to_cpu(entry->e_value_size);
 
-	if (buffer && value_len > buffer_size) {
+	if (buffer && size > buffer_size) {
 		error = -ERANGE;
 		goto cleanup;
 	}
 
 	if (buffer) {
 		char *pval = entry->e_name + entry->e_name_len;
-		memcpy(buffer, pval, value_len);
+		memcpy(buffer, pval, size);
 	}
-	error = value_len;
+	error = size;
 
 cleanup:
 	kzfree(base_addr);
@@ -475,15 +477,15 @@ cleanup:
 	return error;
 }
 
-static int __f2fs_setxattr(struct inode *inode, int name_index,
-			const char *name, const void *value, size_t value_len,
+static int __f2fs_setxattr(struct inode *inode, int index,
+			const char *name, const void *value, size_t size,
 			struct page *ipage)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *here, *last;
 	void *base_addr;
 	int found, newsize;
-	size_t name_len;
+	size_t len;
 	__u32 new_hsize;
 	int error = -ENOMEM;
 
@@ -491,11 +493,11 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 		return -EINVAL;
 
 	if (value == NULL)
-		value_len = 0;
+		size = 0;
 
-	name_len = strlen(name);
+	len = strlen(name);
 
-	if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN(inode))
+	if (len > F2FS_NAME_LEN || size > MAX_VALUE_LEN(inode))
 		return -ERANGE;
 
 	base_addr = read_all_xattrs(inode, ipage);
@@ -503,7 +505,7 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 		goto exit;
 
 	/* find entry with wanted name. */
-	here = __find_xattr(base_addr, name_index, name_len, name);
+	here = __find_xattr(base_addr, index, len, name);
 
 	found = IS_XATTR_LAST_ENTRY(here) ? 0 : 1;
 	last = here;
@@ -511,8 +513,7 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 	while (!IS_XATTR_LAST_ENTRY(last))
 		last = XATTR_NEXT_ENTRY(last);
 
-	newsize = XATTR_ALIGN(sizeof(struct f2fs_xattr_entry) +
-			name_len + value_len);
+	newsize = XATTR_ALIGN(sizeof(struct f2fs_xattr_entry) + len + size);
 
 	/* 1. Check space */
 	if (value) {
@@ -555,12 +556,12 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 		 * We just write new entry.
 		 */
 		memset(last, 0, newsize);
-		last->e_name_index = name_index;
-		last->e_name_len = name_len;
-		memcpy(last->e_name, name, name_len);
-		pval = last->e_name + name_len;
-		memcpy(pval, value, value_len);
-		last->e_value_size = cpu_to_le16(value_len);
+		last->e_name_index = index;
+		last->e_name_len = len;
+		memcpy(last->e_name, name, len);
+		pval = last->e_name + len;
+		memcpy(pval, value, size);
+		last->e_value_size = cpu_to_le16(size);
 		new_hsize += newsize;
 	}
 
@@ -583,8 +584,9 @@ exit:
 	return error;
 }
 
-int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
-			const void *value, size_t value_len, struct page *ipage)
+int f2fs_setxattr(struct inode *inode, int index, const char *name,
+				const void *value, size_t size,
+				struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int err;
@@ -594,7 +596,7 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	f2fs_lock_op(sbi);
 	/* protect xattr_ver */
 	down_write(&F2FS_I(inode)->i_sem);
-	err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
+	err = __f2fs_setxattr(inode, index, name, value, size, ipage);
 	up_write(&F2FS_I(inode)->i_sem);
 	f2fs_unlock_op(sbi);
 
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index b21d9eb..79bc2bb 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -120,12 +120,12 @@ extern ssize_t f2fs_listxattr(struct dentry *, char *, size_t);
 #else
 
 #define f2fs_xattr_handlers	NULL
-static inline int f2fs_setxattr(struct inode *inode, int name_index,
-		const char *name, const void *value, size_t value_len)
+static inline int f2fs_setxattr(struct inode *inode, int index,
+		const char *name, const void *value, size_t size)
 {
 	return -EOPNOTSUPP;
 }
-static inline int f2fs_getxattr(struct inode *inode, int name_index,
+static inline int f2fs_getxattr(struct inode *inode, int index,
 		const char *name, void *buffer, size_t buffer_size)
 {
 	return -EOPNOTSUPP;
-- 
1.8.4.474.g128a96c

