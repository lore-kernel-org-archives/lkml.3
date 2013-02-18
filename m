Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3BRBMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:12:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51502 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BRBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:12:44 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sun, 17 Feb 2013 17:11:09 -0800
Message-Id: <1361149870-27732-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18qb1ykfwM8+jEXvosYSJWl7xMmD9/LqY4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0070]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 16/16] userns: Remove the EXPERMINTAL kconfig tag
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

While there is more work to be done in the form of allowing
more to happen when you have root inside of a user namespace
there is nothing experimental about them.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 init/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c22e1b9..f2b1419 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1026,8 +1026,7 @@ config IPC_NS
 	  different IPC objects in different namespaces.
 
 config USER_NS
-	bool "User namespace (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "User namespace"
 	default n
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
-- 
1.7.5.4

