Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaK3Lfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:35:50 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaK3Lfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:35:48 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fastmap update v2 (pile 2)
Date: Sun, 30 Nov 2014 12:35:34 +0100
Message-Id: <1417347340-6872-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

this is pile 2 of 7.

[PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the WL
[PATCH 2/6] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
[PATCH 3/6] UBI: Fastmap: Notify user in case of an
[PATCH 4/6] UBI: Fastmap: Wrap fastmap specific function in a ifdef
[PATCH 5/6] UBI: Fastmap: Fix fastmap usage in ubi_volume_notify()
[PATCH 6/6] UBI: Fastmap: Fix memory leak while attaching

Thanks,
//richard
