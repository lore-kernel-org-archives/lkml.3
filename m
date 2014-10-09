Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaJIIE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:04:29 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:52670 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbaJIIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:04:08 -0400
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
To: jan.kiszka@siemens.com
Cc: linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH v0] scripts/gdb: Use a generator instead of iterator for task list
Date: Thu,  9 Oct 2014 10:03:58 +0200
Message-Id: <1412841839-24537-1-git-send-email-daniel.wagner@bmw-carit.de>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to debug something here and gave your patches a spin.
I found a small issue when trying to access threads instead only
processes. 

See you next week in Duesseldorf!

Daniel Wagner (1):
  scripts/gdb: Use a generator instead of iterator for task list

 scripts/gdb/linux/tasks.py | 50 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

-- 
1.9.3

