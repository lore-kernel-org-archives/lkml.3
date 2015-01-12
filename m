Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbALQbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:31:46 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55491 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbALQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:31:45 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH] staging: android: Fixing checkpatch.pl warning
Date: Mon, 12 Jan 2015 17:31:20 +0100
Message-Id: <1421080281-6889-1-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a linewidth issue. Based on 3.19-rc4.

Moritz Fischer (1):
  staging: android: Fixed checkpatch.pl warning

 drivers/staging/android/sync_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.9.3

