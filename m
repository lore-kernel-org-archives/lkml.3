Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3BRBNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:13:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40470 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3BRBMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:12:42 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:07 -0800
Message-Id: <1361149870-27732-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19j/WyJNxbJlHMqYhjC06Ed4FfrEJhzoik=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0220]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 14/16] xfs: Enable building with user namespaces enabled.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Not that all of the types holding uids, gids, and projectids
have been converted it is safe to allow users in different
user namespaces to access an xfs filesystem.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b2de5ed..3d99394 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1071,7 +1071,6 @@ config UIDGID_CONVERTED
 	default y
 
 	# Filesystems
-	depends on XFS_FS = n
 
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
-- 
1.7.5.4

