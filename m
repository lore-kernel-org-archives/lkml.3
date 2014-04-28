Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbaD1UT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:19:57 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:42777 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197AbaD1UTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:19:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgTAAO3XlNXQw00/2dsb2JhbABZgwasDQUBAQEFmXICAoEaF3SCZhwjGIECJBOIRQHJHIVaiH+EQASOfIoPAZJegzM7
Date: Mon, 28 Apr 2014 22:21:57 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS/BEFS: kernel-doc fixes
Message-Id: <20140428222157.595c5066e025718072369f07@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some comment errors.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/btree.c      |  4 ++--
 fs/befs/datastream.c |  2 +-
 fs/befs/linuxvfs.c   | 16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index a2cd305..28b9eef 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -318,7 +318,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
  * befs_find_key - Search for a key within a node
  * @sb: Filesystem superblock
  * @node: Node to find the key within
- * @key: Keystring to search for
+ * @findkey: Keystring to search for
  * @value: If key is found, the value stored with the key is put here
  *
  * finds exact match if one exists, and returns BEFS_BT_MATCH
@@ -707,7 +707,7 @@ befs_bt_get_key(struct super_block *sb, befs_btree_node * node,
  * @key1: pointer to the first key to be compared 
  * @keylen1: length in bytes of key1
  * @key2: pointer to the second key to be compared
- * @kelen2: length in bytes of key2
+ * @keylen2: length in bytes of key2
  *
  * Returns 0 if @key1 and @key2 are equal.
  * Returns >0 if @key1 is greater.
diff --git a/fs/befs/datastream.c b/fs/befs/datastream.c
index c467beb..1e8e0b8 100644
--- a/fs/befs/datastream.c
+++ b/fs/befs/datastream.c
@@ -116,7 +116,7 @@ befs_fblock2brun(struct super_block *sb, befs_data_stream * data,
  * befs_read_lsmylink - read long symlink from datastream.
  * @sb: Filesystem superblock 
  * @ds: Datastrem to read from
- * @buf: Buffer in which to place long symlink data
+ * @buff: Buffer in which to place long symlink data
  * @len: Length of the long symlink in bytes
  *
  * Returns the number of bytes read
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d626756..1f5b966 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -591,21 +591,21 @@ befs_utf2nls(struct super_block *sb, const char *in,
 /**
  * befs_nls2utf - Convert NLS string to utf8 encodeing
  * @sb: Superblock
- * @src: Input string buffer in NLS format
- * @srclen: Length of input string in bytes
- * @dest: The output string in UTF-8 format
- * @destlen: Length of the output buffer
+ * @in: Input string buffer in NLS format
+ * @in_len: Length of input string in bytes
+ * @out: The output string in UTF-8 format
+ * @out_len: Length of the output buffer
  * 
- * Converts input string @src, which is in the format of the loaded NLS map,
+ * Converts input string @in, which is in the format of the loaded NLS map,
  * into a utf8 string.
  * 
- * The destination string @dest is allocated by this function and the caller is
+ * The destination string @out is allocated by this function and the caller is
  * responsible for freeing it with kfree()
  * 
- * On return, *@destlen is the length of @dest in bytes.
+ * On return, *@out_len is the length of @out in bytes.
  *
  * On success, the return value is the number of utf8 characters written to
- * the output buffer @dest.
+ * the output buffer @out.
  *  
  * On Failure, a negative number coresponding to the error code is returned.
  */
-- 
1.8.4.5

