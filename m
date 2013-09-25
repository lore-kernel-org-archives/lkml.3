Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3IYAN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab3IYAN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:13:56 -0400
Date: Tue, 24 Sep 2013 20:13:44 -0400
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix apparent cut-n-paste mistake in Dell reboot workaround.
Message-ID: <20130925001344.GA13554@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to have been copied from the Optiplex 990 entry above, but somoene
forgot to change the ident text.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f6835d8..ea2aaca 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -360,7 +360,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	},
 	{	/* Handle problems with rebooting on the Precision M6600. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell Precision M6600",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
