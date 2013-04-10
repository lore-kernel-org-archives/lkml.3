Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3DJT0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab3DJT0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:26:44 -0400
Message-ID: <1365621996.15949.3.camel@t520.redhat.com>
Subject: [GIT PULL] c6x: add memory barrier to arch_local_irq_restore
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "JACQUIOT-XID, Aurelien" <a-jacquiot@ti.com>
Date: Wed, 10 Apr 2013 15:26:36 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to f934af05cb1bf20558542185299394a69060b829:

  add memory barrier to arch_local_irq_restore (2013-04-09 15:35:46 -0400)

----------------------------------------------------------------
C6X fixes for v3.9

----------------------------------------------------------------
Mark Salter (1):
      add memory barrier to arch_local_irq_restore

 arch/c6x/include/asm/irqflags.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


