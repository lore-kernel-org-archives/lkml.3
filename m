Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaKXSzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:55:55 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38120 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaKXSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:55:54 -0500
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Subject: [PATCH 0/2] fix some sparse warnings in lustre
Date: Mon, 24 Nov 2014 19:55:40 +0100
Message-Id: <cover.1416853961.git.zahari.doychev@linux.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two patches fix several sparse warning in the lustre module.

Zahari Doychev (2):
  [drivers] staging/lustre: fix sparse warnings
  [drivers] staging/lustre: fix sparse warnings

 drivers/staging/lustre/include/linux/lnet/lib-lnet.h   | 14 +++++++++-----
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 15 ++++++++++-----
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.1.0

