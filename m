Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaCIRBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaCIRBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:01:09 -0400
From: Mark Salter <msalter@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: Mark Salter <msalter@redhat.com>, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v6 6/6] doc/kernel-parameters.txt: add early_ioremap_debug
Date: Sun,  9 Mar 2014 13:00:44 -0400
Message-Id: <1394384444-23182-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1394384444-23182-1-git-send-email-msalter@redhat.com>
References: <1394384444-23182-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description of early_ioremap_debug kernel parameter.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 Documentation/kernel-parameters.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..de1d10e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -870,6 +870,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Enable debug messages at boot time.  See
 			Documentation/dynamic-debug-howto.txt for details.
 
+	early_ioremap_debug [KNL]
+			Enable debug messages in early_ioremap support. This
+			is useful for tracking down temporary early mappings
+			which are not unmapped.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
-- 
1.8.5.3

