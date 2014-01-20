Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaATSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:16:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaATSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:16:53 -0500
Date: Mon, 20 Jan 2014 10:16:21 -0800
From: tip-bot for Alan <tipbot@zytor.com>
Message-ID: <tip-b8989db9d82465bf38a48a4d3ef32e7d8afc4d08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        gnomes@lxorguk.ukuu.org.uk, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, gnomes@lxorguk.ukuu.org.uk,
        alan@linux.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20140120180056.7173.62222.stgit@alan.etchedpixels.co.uk>
References: <20140120180056.7173.62222.stgit@alan.etchedpixels.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc, kconfig:
  Fix dud URL for Microcode data
Git-Commit-ID: b8989db9d82465bf38a48a4d3ef32e7d8afc4d08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 10:16:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8989db9d82465bf38a48a4d3ef32e7d8afc4d08
Gitweb:     http://git.kernel.org/tip/b8989db9d82465bf38a48a4d3ef32e7d8afc4d08
Author:     Alan <gnomes@lxorguk.ukuu.org.uk>
AuthorDate: Mon, 20 Jan 2014 18:01:56 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 10:12:29 -0800

x86, doc, kconfig: Fix dud URL for Microcode data

The actual data lives in the Intel download center, and that ought to also
be a reliable way to continue to find it. Unfortunately the actual URL
needed for doing it directly is about a foot long so give instructions.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20140120180056.7173.62222.stgit@alan.etchedpixels.co.uk
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..64199bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1064,9 +1064,9 @@ config MICROCODE_INTEL
 	  This options enables microcode patch loading support for Intel
 	  processors.
 
-	  For latest news and information on obtaining all the required
-	  Intel ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
+	  For the current Intel microcode data package go to
+	  <https://downloadcenter.intel.com> and search for
+	  'Linux Processor Microcode Data File'.
 
 config MICROCODE_AMD
 	bool "AMD microcode loading support"
