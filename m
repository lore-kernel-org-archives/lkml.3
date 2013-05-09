Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3EIJQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:16:15 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44707 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3EIJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:16:13 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, j-nomura@ce.jp.nec.com
Subject: [PATCH 0/3] KVM: emulate AAM, XLAT, SALC
Date: Thu,  9 May 2013 11:16:04 +0200
Message-Id: <1368090967-3204-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three instructions are not emulated, but can be found in
real mode code.

These are also good for stable, but they conflict before 3.9 and are
not really useful since emulate_invalid_guest_state defaulted to false.
So I'm not marking them for earlier releases.

Paolo Bonzini (3):
  KVM: emulator: emulate AAM
  KVM: emulator: emulate XLAT
  KVM: emulator: emulate SALC

 arch/x86/kvm/emulate.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

-- 
1.8.1.4

