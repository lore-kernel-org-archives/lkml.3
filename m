Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaLWAk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:40:57 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:57431 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaLWAkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:40:09 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/2] x86, vdso, pvclock: Cleanups and speedups
Date: Mon, 22 Dec 2014 16:39:55 -0800
Message-Id: <cover.1419295081.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a dramatic simplification and speedup of the vdso pvclock read
code.  Is it correct?

Andy Lutomirski (2):
  x86, vdso: Use asm volatile in __getcpu
  x86, vdso, pvclock: Simplify and speed up the vdso pvclock reader

 arch/x86/include/asm/vgtod.h   |  6 ++--
 arch/x86/vdso/vclock_gettime.c | 82 ++++++++++++++++++++++++------------------
 2 files changed, 51 insertions(+), 37 deletions(-)

-- 
2.1.0

