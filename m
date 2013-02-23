Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3BWHb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:31:29 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46574 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab3BWHbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:31:25 -0500
Date: Fri, 22 Feb 2013 23:29:59 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130223072959.GA4894@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 93ff4e1..8cada4c 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -53,7 +53,7 @@ config XEN_DEBUG_FS
 
 config XEN_X86_PVH
 	bool "Support for running as a PVH guest (EXPERIMENTAL)"
-	depends on X86_64 && XEN && EXPERIMENTAL
+	depends on X86_64 && XEN
 	default n
 	help
 	   This option enables support for running as a PVH guest (PV guest
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
