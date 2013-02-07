Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3BGOia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:38:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44669 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab3BGOi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:38:28 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] Fix ARM build error on 3.8-rc6
Date: Thu, 7 Feb 2013 16:35:51 +0200
Message-ID: <1360247752-25681-1-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Building ARM kernel with allyesconfig fails currently on 3.8-rc6. Here's a
patch to fix this issue.

Arnd asked me to send this directly to you, as there are no other pending
arm-soc fixes.

 Tomi

Tomi Valkeinen (1):
  omapdrm: fix the dependency to omapdss

 drivers/staging/omapdrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

