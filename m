Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaB1PDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:03:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23102 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaB1PBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:36 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e9-5310a4cf9a68
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 4/8] evm: EVM does not use MD5
Date: Fri, 28 Feb 2014 16:59:28 +0200
Message-id: <e0a79642b9e1ab8c63ea5a7a7af93fc319e366b0.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7rnlwgEG+w4L2NxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugStj7aVlbAUbWSomLtvK3sB4hbmLkZNDQsBEYvKTVihbTOLC
	vfVsXYxcHEICSxklXl7bwwrhdDJJrP+yjR2kik1AT2JD8w8wW0TAWWLRrXawImaBqYwSr25N
	YwFJCAMV/di4B6yIRUBVYtK3h0wgNq9AnMStP9+ZINYpSCz7shZsNaeAlcSWy/dYQWwhAUuJ
	q8/msuESn8DIv4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSDh+2cG4+JjVIUYBDkYl
	Hl6JRQLBQqyJZcWVuYcYJTiYlUR4p88HCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDcEql98Ym/
	2Efm+xmiS08qPpOesM7MP9Hl66E7f1JETvSvqlm5mOucp6vo6sMdZb5rjkVNa3/Kosb7nqW8
	y995K9c8Fd1ns1V8lauPtnJOCTVpPKCudKhMRav/7ecXxv+FE3Lu/Y52vJi3wzZHfI5UAesk
	zc0ed/d9f9Z7/ZI580NDdze1rrVKLMUZiYZazEXFiQAGgovPJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index fea9749..5aa9103 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -2,7 +2,6 @@ config EVM
 	boolean "EVM support"
 	depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
 	select CRYPTO_HMAC
-	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select ENCRYPTED_KEYS
 	default n
-- 
1.8.3.2

