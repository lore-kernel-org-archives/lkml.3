Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3HGK1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:27:38 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56442 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab3HGK1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:36 -0400
Date: Wed, 7 Aug 2013 12:20:58 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 20/26] x86 STA2X11 platform: remove useless pr_info()'s
Message-ID: <714a6e4773977fb716ddde077b6f574e1ed7f8b6.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/platform/sta2x11/sta2x11.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
index 57ed10d..b3e9cec 100644
--- a/arch/x86/platform/sta2x11/sta2x11.c
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -374,7 +374,6 @@ static struct platform_driver sta2x11_sctl_platform_driver = {
 
 static int __init sta2x11_sctl_init(void)
 {
-	pr_info("%s\n", __func__);
 	return platform_driver_register(&sta2x11_sctl_platform_driver);
 }
 
@@ -394,7 +393,6 @@ static struct platform_driver sta2x11_apbreg_platform_driver = {
 
 static int __init sta2x11_apbreg_init(void)
 {
-	pr_info("%s\n", __func__);
 	return platform_driver_register(&sta2x11_apbreg_platform_driver);
 }
 
@@ -414,7 +412,6 @@ static struct platform_driver sta2x11_apb_soc_regs_platform_driver = {
 
 static int __init sta2x11_apb_soc_regs_init(void)
 {
-	pr_info("%s\n", __func__);
 	return platform_driver_register(&sta2x11_apb_soc_regs_platform_driver);
 }
 
@@ -434,7 +431,6 @@ static struct platform_driver sta2x11_scr_platform_driver = {
 
 static int __init sta2x11_scr_init(void)
 {
-	pr_info("%s\n", __func__);
 	return platform_driver_register(&sta2x11_scr_platform_driver);
 }
 
-- 
1.7.7.2
