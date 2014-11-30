Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaK3MPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:15:38 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaK3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:35 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 5)
Date: Sun, 30 Nov 2014 13:15:22 +0100
Message-Id: <1417349728-9070-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

this is pile 5 of 7.

[PATCH 1/6] UBI: Add initial support for fastmap self checks
[PATCH 2/6] UBI: Fastmap: Enhance fastmap checking
[PATCH 3/6] UBI: Fix stale pointers in ubi->lookuptbl
[PATCH 4/6] UBI: Fastmap: Add self check to detect absent PEBs
[PATCH 5/6] UBI: Fastmap: Make self_check_eba() depend on fastmap
[PATCH 6/6] UBI: Fastmap: Add new module parameter fm_debug

Thanks,
//richard
