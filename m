Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab3BMR5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49075 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963Ab3BMR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:50 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>
Date: Wed, 13 Feb 2013 09:51:09 -0800
Message-Id: <1360777934-5663-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19MXMEkl9uLzAQbs8mo0NxAETu3FUfEx1M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 20/85] coda: Allow coda to be built when user namespace support is enabled
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Now that the coda kernel to userspace has been modified to convert
between kuids and kgids and uids and gids, and all internal
coda structures have be modified to store uids and gids as
kuids and kgids it is safe to allow code to be built with
user namespace support enabled.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4570b02..f516d52 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1072,7 +1072,6 @@ config UIDGID_CONVERTED
 
 	# Filesystems
 	depends on CIFS = n
-	depends on CODA_FS = n
 	depends on GFS2_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
-- 
1.7.5.4

