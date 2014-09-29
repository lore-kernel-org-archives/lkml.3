Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaI2WVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:21:07 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaI2WU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:20:58 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: UBI: Fastmap fixes - round one
Date: Tue, 30 Sep 2014 00:20:44 +0200
Message-Id: <1412029248-22454-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first set of fastmap fixes for v3.18.
I have more in my local queue but these depend on non-trivial
fastmap changes I made. As soon they have been fully tested I'll
submitt them too.

Thanks,
//richard

[PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
[PATCH 2/4] UBI: Fastmap: Calc fastmap size correctly
[PATCH 3/4] UBI: Fastmap: Care about the protection queue
[PATCH 4/4] UBI: Fastmap: Ensure that only one fastmap work is
