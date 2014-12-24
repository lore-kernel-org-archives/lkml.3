Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaLXGtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:49:55 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:58648 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaLXGty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:49:54 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kbuild: Refactor ./Kbuild
Date: Wed, 24 Dec 2014 15:49:23 +0900
Message-Id: <1419403765-3377-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Masahiro Yamada (2):
  kbuild: merge bounds.h and asm-offsets.h rules
  kbuild: remove redundant line from bounds.h/asm-offsets.h

 Kbuild | 60 +++++++++++++++++++++---------------------------------------
 1 file changed, 21 insertions(+), 39 deletions(-)

-- 
1.9.1

