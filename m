Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbbAWIcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:32:04 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:49085 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbAWIcB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 03:32:01 -0500
Message-Id: <54C21511020000780005890E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:32:01 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@alien8.de>, <tony.luck@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: x86/MCE: drop bogus const modifier from AMD's bank4_names()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler validly warns about it being ignored.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.19-rc5/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ 3.19-rc5-x86-MCE-AMD-bank4_names/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -79,7 +79,7 @@ static inline bool is_shared_bank(int ba
 	return (bank == 4);
 }
 
-static const char * const bank4_names(struct threshold_block *b)
+static const char *bank4_names(const struct threshold_block *b)
 {
 	switch (b->address) {
 	/* MSR4_MISC0 */



