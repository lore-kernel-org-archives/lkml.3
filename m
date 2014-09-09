Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaIILEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:04:02 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:56750 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbaIILCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:02:30 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 0/3] kbuild: better implementation to display "Entering directory ..."
Date: Tue,  9 Sep 2014 20:02:21 +0900
Message-Id: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Masahiro Yamada (3):
  kbuild: fake the "Entering directory ..." message more simply
  kbuild: use $(Q) for sub-make target
  kbuild: handle C=... and M=... after entering into build directory

 Makefile | 82 ++++++++++++++++++++++++++++++----------------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

-- 
1.9.1

