Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3GKWNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:13:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab3GKWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [ 07/11] MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
Date: Thu, 11 Jul 2013 15:11:07 -0700
Message-Id: <20130711220546.392644563@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7b175c46720f8e6b92801bb634c93d1016f80c62 upstream.

This hopefully will help point developers to the proper way that patches
should be submitted for inclusion in the stable kernel releases.

Reported-by: David Howells <dhowells@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6390,6 +6390,7 @@ STABLE BRANCH
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	stable@vger.kernel.org
 S:	Supported
+F:	Documentation/stable_kernel_rules.txt
 
 STAGING SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>


