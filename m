Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3FZMFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:05:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FZMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:05:29 -0400
Date: Wed, 26 Jun 2013 05:05:06 -0700
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-cb7b80237a9f41edf2ebd899bc6a443db05578c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, jnakajim@gmail.com, ben@decadent.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jnakajim@gmail.com, ben@decadent.org.uk
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform:
  Make X86_GOLDFISH depend on X86_EXTENDED_PLATFORM
Git-Commit-ID: cb7b80237a9f41edf2ebd899bc6a443db05578c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:05:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb7b80237a9f41edf2ebd899bc6a443db05578c5
Gitweb:     http://git.kernel.org/tip/cb7b80237a9f41edf2ebd899bc6a443db05578c5
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Mon, 24 Jun 2013 01:05:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 13:28:54 +0200

x86/platform: Make X86_GOLDFISH depend on X86_EXTENDED_PLATFORM

All non-PC platforms are supposed to be dependent on this
option.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jun Nakajima <jnakajim@gmail.com>
Link: http://lkml.kernel.org/n/tip-Bcihhqhstm67fchjnkxoiJbu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..9359d23 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -336,6 +336,7 @@ config X86_EXTENDED_PLATFORM
 
 	  If you enable this option then you'll be able to select support
 	  for the following (non-PC) 32 bit x86 platforms:
+		Goldfish (Android emulator)
 		AMD Elan
 		NUMAQ (IBM/Sequent)
 		RDC R-321x SoC
@@ -410,6 +411,7 @@ config X86_UV
 config X86_GOLDFISH
        bool "Goldfish (Virtual Platform)"
        depends on X86_32
+       depends on X86_EXTENDED_PLATFORM
        ---help---
 	 Enable support for the Goldfish virtual platform used primarily
 	 for Android development. Unless you are building for the Android
