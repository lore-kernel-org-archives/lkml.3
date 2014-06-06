Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaFFL5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:57:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37299 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFFL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:57:07 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@linaro.org, Magnus Damm <magnus.damm@gmail.com>,
        robh+dt@kernel.org
Date: Fri, 06 Jun 2014 20:59:09 +0900
Message-Id: <20140606115909.4584.28612.sendpatchset@w520>
Subject: [PATCH 00/02] of: Add two stubs for OF_ADDRESS=n and OF=n cases
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of: Add two stubs for OF_ADDRESS=n and OF=n cases

[PATCH 01/02] of: Add OF_ADDRESS=n stub for of_can_translate_address()
[PATCH 02/02] of: Add OF=n stub for of_find_all_nodes()

This series adds include file stubs for the following functions:
- of_can_translate_address() in of_address.h
- of_find_all_nodes() in of.h

With these stubs in place it is possible to remove Kconfig
dependencies for OF and OF_ADDRESS in certain cases and just
depend on the default behaviour of the stubs.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Written against renesas git repo at kernel.org using tag
 renesas-devel-v3.15-rc8-20140606 which for this code is
 the same as v3.15-rc8. Let me know if you want me to rebase.

 include/linux/of.h         |    5 +++++
 include/linux/of_address.h |    5 +++++
 2 files changed, 10 insertions(+)
