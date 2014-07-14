Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaGNShx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:37:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37816 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:37:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 14 Jul 2014 20:37:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20140714203734.1afa1021@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fix" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix

to receive an IEEE 1394 (FireWire) subsystem fix:  The 1394 drivers cannot and
are not supposed to be built on platforms which don't provide the DMA mapping API.
(Regression since v3.16-rc1 with CONFIG_COMPILE_TEST=y on some architectures.)

Geert Uytterhoeven (1):
      firewire: IEEE 1394 (FireWire) support should depend on HAS_DMA

 drivers/firewire/Kconfig | 1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Stefan Richter
-=====-====- -=== -===-
http://arcgraph.de/sr/
