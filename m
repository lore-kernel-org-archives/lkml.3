Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbaGRUwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:52:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31171 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaGRUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:52:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/QqzIsw17NyybCfySDNmlNewEAR395iNk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 91FA25AFC2D
Date: Fri, 18 Jul 2014 16:52:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Fixes for v3.16 (round #2)
Message-ID: <20140718205238.GJ24496@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's all of the fixes I have queued up for v3.16.  Nothing else is
allowed to break ;-)

This is an incremental pull request on the irqchip/urgent branch from
tags/irqchip-urgent-3.16 up to tags/irqchip-urgent-3.16-2.

Please pull.

thx,

Jason.


The following changes since commit 4f4366033945419b0c52118c29d3057d7c558765:

  irqchip: spear_shirq: Fix interrupt offset (2014-06-21 23:26:39 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.16-2

for you to fetch changes up to 29e697b11853d3f83b1864ae385abdad4aa2c361:

  irqchip: gic: Fix core ID calculation when topology is read from DT (2014-07-18 13:13:41 +0000)

----------------------------------------------------------------
irqchip fixes for v3.16 (round #2)

 - gic
   - Add Cortex A7 compatible string
   - Add gic400 compatible string
   - Fix core ID calc when topology is present in DT

----------------------------------------------------------------
Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Suravee Suthikulpanit (1):
      irqchip: gic: Add binding probe for ARM GIC400

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT

 drivers/irqchip/irq-gic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
