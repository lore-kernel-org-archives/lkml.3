Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaBUWDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:03:50 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11798 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaBUWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:03:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wrNIhmOpMp7VxzS3F7AFBWzJXJqsuUFc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2155A52FB93
Date: Fri, 21 Feb 2014 17:03:30 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL V2] irqchip: mvebu fixes for v3.14
Message-ID: <20140221220330.GN7862@titan.lakedaemon.net>
References: <20140218162210.GU7862@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218162210.GU7862@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here it is.  Sorry for the delay.  I was under the weather past couple
days.

thx,

Jason.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-mvebu.git tags/irqchip-mvebu-fixes-3.14

for you to fetch changes up to d86e9af6336c0ad586a5dbd70064253d40bbb5ff:

  irqchip: orion: Fix getting generic chip pointer. (2014-02-21 21:46:56 +0000)

----------------------------------------------------------------
irqchip mvebu fixes for v3.14

 - orion:
    - fixes for clearing bridge cause register, and clearing stale interrupts

----------------------------------------------------------------
Andrew Lunn (1):
      irqchip: orion: Fix getting generic chip pointer.

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

 drivers/irqchip/irq-orion.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)
