Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbbAEG5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:57:35 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:37961 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbAEG5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:57:33 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] kbuild: Refactor ./Kbuild
Date: Mon,  5 Jan 2015 15:57:14 +0900
Message-Id: <1420441036-5289-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Changes in v2:
  - Pass the include guard as an argument of cmd_offsets
    as Michal Marek suggested.

Masahiro Yamada (2):
  kbuild: merge bounds.h and asm-offsets.h rules
  kbuild: remove redundant line from bounds.h/asm-offsets.h

 Kbuild | 61 +++++++++++++++++++++----------------------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

-- 
1.9.1

