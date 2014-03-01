Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaCAIl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 03:41:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63466 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaCAIl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 03:41:58 -0500
From: Masood Mehmood <ody.guru@gmail.com>
To: gregkh@linuxfoundation.org
Cc: freemangordon@abv.bg, akpm@linux-foundation.org, tj@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: fixed space coding style
Date: Sat,  1 Mar 2014 00:41:55 -0800
Message-Id: <1393663315-6481-1-git-send-email-ody.guru@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Adjusted pointer's '*' declaration to the data_type.
- Added space after 'if' keyword

Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
---
 drivers/staging/tidspbridge/dynload/tramp.c | 2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c    | 4 ++--
 drivers/staging/tidspbridge/rmgr/drv.c      | 2 +-
 drivers/staging/tidspbridge/rmgr/nldr.c     | 2 +-
 drivers/staging/tidspbridge/rmgr/node.c     | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/tramp.c b/drivers/staging/tidspbridge/dynload/tramp.c
index 404af18..5f04313 100644
--- a/drivers/staging/tidspbridge/dynload/tramp.c
+++ b/drivers/staging/tidspbridge/dynload/tramp.c
@@ -503,7 +503,7 @@ static int priv_tgt_img_gen(struct dload_state *dlthis, u32 base,
  *	  TRAMPOLINES ARE TREATED AS 2ND PASS even though this is really
  *	  the first (and only) relocation that will be performed on them.
  */
-static int priv_pkt_relo(struct dload_state *dlthis, tgt_au_t * data,
+static int priv_pkt_relo(struct dload_state *dlthis, tgt_au_t *data,
 			 struct reloc_record_t *rp[], u32 relo_count)
 {
 	int ret_val = 1;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 190ca3f..2ae48c9 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -101,14 +101,14 @@ static int dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
 	 * if the converted value doesn't fit in u32. So, convert the
 	 * last six bytes to u64 and memcpy what is needed
 	 */
-	if(sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
+	if (sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
 	       &uuid_tmp.data1, &c, &uuid_tmp.data2, &c,
 	       &uuid_tmp.data3, &c, &uuid_tmp.data4,
 	       &uuid_tmp.data5, &c, &t) != 10)
 		return -EINVAL;
 
 	t = cpu_to_be64(t);
-	memcpy(&uuid_tmp.data6[0], ((char*)&t) + 2, 6);
+	memcpy(&uuid_tmp.data6[0], ((char *)&t) + 2, 6);
 	*uuid_obj = uuid_tmp;
 
 	return 0;
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index be26917..757ae20 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -738,7 +738,7 @@ void mem_ext_phys_pool_release(void)
  *     Allocate physically contiguous, uncached memory from external memory pool
  */
 
-static void *mem_ext_phys_mem_alloc(u32 bytes, u32 align, u32 * phys_addr)
+static void *mem_ext_phys_mem_alloc(u32 bytes, u32 align, u32 *phys_addr)
 {
 	u32 new_alloc_ptr;
 	u32 offset;
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index ca38050..7e10c95 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -623,7 +623,7 @@ void nldr_delete(struct nldr_object *nldr_obj)
  *  ======== nldr_get_fxn_addr ========
  */
 int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
-			     char *str_fxn, u32 * addr)
+			     char *str_fxn, u32 *addr)
 {
 	struct dbll_sym_val *dbll_sym;
 	struct nldr_object *nldr_obj;
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 87dfa92..c0211dd 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -246,7 +246,7 @@ static void fill_stream_def(struct node_object *hnode,
 			    struct node_strmdef *pstrm_def,
 			    struct dsp_strmattr *pattrs);
 static void free_stream(struct node_mgr *hnode_mgr, struct stream_chnl stream);
-static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
+static int get_fxn_address(struct node_object *hnode, u32 *fxn_addr,
 				  u32 phase);
 static int get_node_props(struct dcd_manager *hdcd_mgr,
 				 struct node_object *hnode,
@@ -1576,7 +1576,7 @@ func_end:
  *  Purpose:
  *      Frees the message buffer.
  */
-int node_free_msg_buf(struct node_object *hnode, u8 * pbuffer,
+int node_free_msg_buf(struct node_object *hnode, u8 *pbuffer,
 			     struct dsp_bufferattr *pattr)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
@@ -2640,7 +2640,7 @@ static void free_stream(struct node_mgr *hnode_mgr, struct stream_chnl stream)
  *  Purpose:
  *      Retrieves the address for create, execute or delete phase for a node.
  */
-static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
+static int get_fxn_address(struct node_object *hnode, u32 *fxn_addr,
 				  u32 phase)
 {
 	char *pstr_fxn_name = NULL;
-- 
1.8.3.1

