Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaJ1Di0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:38:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaJ1DiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, qge@redhat.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 3.17 044/146] Drivers: hv: util: Properly pack the data for file copy functionality
Date: Tue, 28 Oct 2014 11:33:06 +0800
Message-Id: <20141028033345.328859359@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit bc5a5b02331a3175a5fca20a4beba249e573b672 upstream.

Properly pack the data for file copy functionality. Patch based on
investigation done by Matej Muzila <mmuzila@redhat.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: <qge@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/hyperv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -137,7 +137,7 @@ struct hv_do_fcopy {
 	__u64	offset;
 	__u32	size;
 	__u8	data[DATA_FRAGMENT];
-};
+} __attribute__((packed));
 
 /*
  * An implementation of HyperV key value pair (KVP) functionality for Linux.


