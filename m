Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3JaKyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:54:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53552 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3JaKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:54:52 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 2/3] Documentation/kvm: patches should be against linux.git
Date: Thu, 31 Oct 2013 16:16:35 +0530
Message-Id: <1383216396-12869-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0
In-Reply-To: <1383216396-12869-1-git-send-email-artagnon@gmail.com>
References: <1383216396-12869-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The document hasn't been updated since cf3e3d3 (KVM: Document KVM
specific review items, 2010-06-24); kvm does not have a separate
repository anymore.

Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Documentation/virtual/kvm/review-checklist.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/review-checklist.txt b/Documentation/virtual/kvm/review-checklist.txt
index a850986..8385c4d 100644
--- a/Documentation/virtual/kvm/review-checklist.txt
+++ b/Documentation/virtual/kvm/review-checklist.txt
@@ -4,7 +4,7 @@ Review checklist for kvm patches
 1.  The patch must follow Documentation/CodingStyle and
     Documentation/SubmittingPatches.
 
-2.  Patches should be against kvm.git master branch.
+2.  Patches should be against linux.git master branch.
 
 3.  If the patch introduces or modifies a new userspace API:
     - the API must be documented in Documentation/virtual/kvm/api.txt
-- 
1.8.5.rc0

