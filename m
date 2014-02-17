Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaBQGUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:20:13 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33500 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaBQGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:20:12 -0500
From: Brian Campbell <brian.campbell@editshare.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, trivial@kernel.org
Subject: [PATCH] user_namespace.c: Remove duplicated word in comment
Date: Sun, 16 Feb 2014 22:58:12 -0500
Message-ID: <87siriqn8u.fsf@gherkin.editshare.boston>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Brian Campbell <brian.campbell@editshare.com>
---
 kernel/user_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 240fb62..dd06439 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -225,7 +225,7 @@ static u32 map_id_up(struct uid_gid_map *map, u32 id)
  *
  *	When there is no mapping defined for the user-namespace uid
  *	pair INVALID_UID is returned.  Callers are expected to test
- *	for and handle handle INVALID_UID being returned.  INVALID_UID
+ *	for and handle INVALID_UID being returned.  INVALID_UID
  *	may be tested for using uid_valid().
  */
 kuid_t make_kuid(struct user_namespace *ns, uid_t uid)
-- 
1.8.5.3

