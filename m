Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaK3Lr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:47:56 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaK3Lrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:47:55 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 3)
Date: Sun, 30 Nov 2014 12:47:40 +0100
Message-Id: <1417348066-7043-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

this is pile 3 of 7.

[PATCH 1/6] UBI: Remove alloc_ai() slab name from parameter list
[PATCH 2/6] UBI: Fastmap: Fix race in ubi_eba_atomic_leb_change()
[PATCH 3/6] UBI: Fastmap: Remove bogus ubi_assert()
[PATCH 4/6] UBI: Fastmap: Remove eba_orphans logic
[PATCH 5/6] UBI: Fastmap: Switch to ro mode if invalidate_fastmap()
[PATCH 6/6] UBI: Fastmap: Make WL pool size 50% of user pool size

Thanks,
//richard
