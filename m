Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaK3MF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:05:56 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaK3MEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:04:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 4)
Date: Sun, 30 Nov 2014 13:04:24 +0100
Message-Id: <1417349070-8894-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

this is pile 4 of 7.

[PATCH 1/6] UBI: Fastmap: Fix leb_count unbalance
[PATCH 2/6] UBI: Fastmap: Fix race after ubi_wl_get_peb()
[PATCH 3/6] UBI: Fastmap: Set used_ebs only for static volumes
[PATCH 4/6] UBI: Fastmap: Locking updates
[PATCH 5/6] UBI: Fastmap: Prepare for variable sized fastmaps
[PATCH 6/6] UBI: Fastmap: Rework fastmap error paths

Thanks,
//richard
