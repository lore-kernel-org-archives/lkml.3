Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3JXFic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:38:32 -0400
Received: from lucifer.kyriasis.com ([106.186.112.63]:36064 "EHLO kyriasis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3JXFib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:38:31 -0400
From: =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres More <more.andres@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
Subject: [PATCH 0/2] Staging: vt6656: fix two coding style issues
Date: Thu, 24 Oct 2013 07:26:45 +0200
Message-Id: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes two coding style issues reported by checkpatch.pl in
drivers/staging/vt6656, one warning and one error

Johannes Löthberg (2):
  Staging: vt6656: fix a brace coding style issue in power.c
  Staging: vt6656: fix code indenting error in power.c

 drivers/staging/vt6656/power.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.8.4.1

