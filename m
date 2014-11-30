Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaK3MUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:20:46 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14391 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaK3MUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:20:04 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 6)
Date: Sun, 30 Nov 2014 13:19:42 +0100
Message-Id: <1417349988-9238-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

this is pile 6 of 7.

[PATCH 1/6] UBI: Move fastmap specific functions out of wl.c
[PATCH 2/6] UBI: Add accessor functions for WL data structures
[PATCH 3/6] UBI: Fastmap: Wire up WL accessor functions
[PATCH 4/6] UBI: Fastmap: Introduce ubi_fastmap_init()
[PATCH 5/6] UBI: Fastmap: Introduce may_reserve_for_fm()
[PATCH 6/6] UBI: Fastmap: Remove else after return.

Thanks,
//richard
