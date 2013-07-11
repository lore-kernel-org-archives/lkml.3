Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3GKWWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3GKWUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [ 6/8] MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
Date: Thu, 11 Jul 2013 15:20:35 -0700
Message-Id: <20130711221931.994089526@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221931.216612791@linuxfoundation.org>
References: <20130711221931.216612791@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5725,6 +5725,7 @@ P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
+F:	Documentation/stable_kernel_rules.txt
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks


