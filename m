Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936162AbaFJA3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:29:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588AbaFJAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 51/88] virtio_console: fix uapi header
Date: Mon,  9 Jun 2014 17:25:01 -0700
Message-Id: <20140610002426.217166129@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 6407d75afd08545f2252bb39806ffd3f10c7faac upstream.

uapi should use __u32 not u32.
Fix a macro in virtio_console.h which uses u32.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/virtio_console.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -39,7 +39,7 @@
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
 
-#define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
+#define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
 
 struct virtio_console_config {
 	/* colums of the screens */


