Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaK1RAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:00:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62167 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaK1RAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:00:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/21o0asmzazfChIgvfxg2KHeFkUumFZCk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 458726263E5
Date: Fri, 28 Nov 2014 12:00:43 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: irqdomain-arm: Heirarchy domain changes for
 v3.19 (round 2)
Message-ID: <20141128170043.GQ22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a small fix to remove a warning introduced by the heirarchy
domain changes.

This is an incremental pull request from tags/irqchip-irqdomain-arm-3.19
up to tags/irqchip-irqdomain-arm-3.19-2 on the irqchip/irqdomain-arm
branch.

Please pull.

thx,

Jason.


The following changes since commit e684e258d831781fd89d2047a272fdb0b0ffe7f4:

  irqchip: gic-v2m: Add DT bindings for GICv2m (2014-11-26 15:55:19 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-irqdomain-arm-3.19-2

for you to fetch changes up to df870c78848aac4d953f61a8926a792de8133b9e:

  irqchip: gic: Remove warning by including linux/irqdomain.h (2014-11-28 16:42:13 +0000)

----------------------------------------------------------------
irqchip hierarchy domain changes for v3.19 (round 2)

 - GIC
    - Remove a series of warnings by including linux/irqdomain.h

----------------------------------------------------------------
Jason Cooper (1):
      irqchip: gic: Remove warning by including linux/irqdomain.h

 include/linux/irqchip/arm-gic.h | 2 ++
 1 file changed, 2 insertions(+)
