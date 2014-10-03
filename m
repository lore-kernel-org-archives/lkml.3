Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbaJDAch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:32:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbaJCVmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.16 134/357] USB: document the u flag for usb-storage quirks parameter
Date: Fri,  3 Oct 2014 14:28:40 -0700
Message-Id: <20141003212937.495714918@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b6089f19fe0cec625b5963a851a07c3e412c27c8 upstream.

Commit d24d481b7d36 (usb-storage: Modify and export adjust_quirks so
that it can be used by uas) added the 'u' flag to the quirks module
parameter for usb-storage, but neglected to update the
documentation.  This patch adds the documentation.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3478,6 +3478,7 @@ bytes respectively. Such letter suffixes
 					bogus residue values);
 				s = SINGLE_LUN (the device has only one
 					Logical Unit);
+				u = IGNORE_UAS (don't bind to the uas driver);
 				w = NO_WP_DETECT (don't test whether the
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc


