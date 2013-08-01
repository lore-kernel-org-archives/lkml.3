Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3HAUWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:22:48 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61898 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3HAUWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:22:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/3] mips/kvm: Code cleanups for kvm_locore.S
Date: Thu,  1 Aug 2013 13:22:32 -0700
Message-Id: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

These shouldn't be too controversial, they just clean things up
without changing the generated code.

More substantial patches will follow, but it seemed like a good idea
to clean this up first.

David Daney (3):
  mips/kvm: Improve code formatting in arch/mips/kvm/kvm_locore.S
  mips/kvm: Cleanup .push/.pop directives in kvm_locore.S
  mips/kvm: Make kvm_locore.S 64-bit buildable/safe.

 arch/mips/kvm/kvm_locore.S | 965 ++++++++++++++++++++++-----------------------
 1 file changed, 480 insertions(+), 485 deletions(-)

-- 
1.7.11.7

