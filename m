Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3J3Tke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab3J3Tkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:40:33 -0400
Date: Wed, 30 Oct 2013 21:43:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm_host: typo fix
Message-ID: <20131030194301.GA26143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix up typo in comment.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0fbbc7a..7445013 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -789,7 +789,7 @@ static inline void kvm_guest_enter(void)
 
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
-	 * is very similar to exiting to userspase from rcu point of view. In
+	 * is very similar to exiting to userspace from rcu point of view. In
 	 * addition CPU may stay in a guest mode for quite a long time (up to
 	 * one time slice). Lets treat guest mode as quiescent state, just like
 	 * we do with user-mode execution.
-- 
MST
