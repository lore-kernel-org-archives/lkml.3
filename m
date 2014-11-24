Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaKXNUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:20:48 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaKXNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 1)
Date: Mon, 24 Nov 2014 14:20:30 +0100
Message-Id: <1416835236-25185-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

as requested I'm resending my fastmap work in smaller pieces.
This is pile 1 of 7.
Rebasing my patches to ubifs.git was a massive PITA because the
logging style changes touched a lot of code and almost every patch
failed to apply and needed inspection by hand.
The first patches are bug fixes, the latter introduce cleanups
and new features.
After all bugfixes are mainline I'll make sure that all needed
fixes go into -stable.

[PATCH 1/6] UBI: Fastmap: Care about the protection queue
[PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
[PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done upon
[PATCH 4/6] UBI: Fastmap: Fix races in ubi_wl_get_peb()
[PATCH 5/6] UBI: Split __wl_get_peb()
[PATCH 6/6] UBI: Fastmap: Make ubi_refill_pools() fair

The whole series can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git fastmap_upgrade2

Thanks,
//richard
