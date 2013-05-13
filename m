Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3EMKz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3EMKz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:55:58 -0400
Date: Mon, 13 May 2013 12:57:20 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/1] powerpc: Fix irq_set_affinity() return values
Message-ID: <20130513105720.GA27065@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

This fix is trivial. Just compile-tested it.

Alexander Gordeev (1):
  powerpc: Fix irq_set_affinity() return values

 arch/powerpc/platforms/wsp/ics.c    |    2 +-
 arch/powerpc/sysdev/ehv_pic.c       |    2 +-
 arch/powerpc/sysdev/mpic.c          |    2 +-
 arch/powerpc/sysdev/xics/ics-opal.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
