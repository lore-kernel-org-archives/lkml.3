Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab3BMSRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:17:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49120 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3BMR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:53 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:44 -0800
Message-Id: <1360777934-5663-55-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+0lTNNh+zx6Du95wVkuOXdRSrPD5HU99c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 55/85] nfs: Convert struct nfs_fattr to Use kuid_t and kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/nfs_xdr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 29adb12..13441dd 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -48,8 +48,8 @@ struct nfs_fattr {
 	unsigned int		valid;		/* which fields are valid */
 	umode_t			mode;
 	__u32			nlink;
-	__u32			uid;
-	__u32			gid;
+	kuid_t			uid;
+	kgid_t			gid;
 	dev_t			rdev;
 	__u64			size;
 	union {
-- 
1.7.5.4

