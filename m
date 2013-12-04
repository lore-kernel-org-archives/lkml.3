Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3LDX31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:29:27 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54180 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3LDX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:29:25 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] MTD maintenance updates
Date: Wed,  4 Dec 2013 15:28:44 -0800
Message-Id: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm taking up where Ezequiel left off on updating MAINTAINERS for MTD [1], with
the following changes:

 1. Get things in alphabetical order.

 2. I think I will be generally helping with all of MTD here, so rather than
    adding a new entry for NAND, just stick me under David Woodhouse. Of
    course, this doesn't quite make me an expert on all areas...

The second patch is just a trivial modification to Ezequiel's 2nd patch.

I agree with Ezequiel's suggestion, that we can assign driver maintainers for
ones that have a particular sense of ownership (e.g., a driver's author, or a
heavily-contributing developer for a driver), and I think this falls in line
with existing practice throughout the kernel. However, this isn't strictly
necessary; for some developers, de facto maintainership can suffice, with no
official role, and get_maintainers.pl pulls suggestions from recent
contribution history in git anyway. So I won't personally push hard for
assigning many driver maintainers.

BTW, I'd like to get David's "ack" for these patches, and it'd be nice to hear
from Artem too, since he has previously been an unofficial maintainer (and is
understandably distracted by non-MTD work these days).

Brian

[1] http://lists.infradead.org/pipermail/linux-mtd/2013-November/050122.html

Brian Norris (1):
  MAINTAINERS: mtd: add Brian Norris for MTD maintenance

Ezequiel Garcia (1):
  MAINTAINERS: mtd: add PXA3xx NAND driver to MAINTAINERS

 MAINTAINERS | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
1.8.5

