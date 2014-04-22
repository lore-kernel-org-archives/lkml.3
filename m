Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbaDVVXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:23 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60145 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaDVVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:20 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 0/6] Staging: rts5139: Fix coding style
Date: Tue, 22 Apr 2014 23:22:58 +0200
Message-Id: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style issues in rts51x.c (from rts5139 module).

Changes in v3:
* removed all the Out Of Memory messages
* redefined pr_fmt to add a prefix to each pr_<level>.
Changes in v2:
* patch splitted to have just one specific coding style issue fixed at a time

Fabio Falzoi (6):
  Staging: rts5139: Camel case labels replaced
  Staging: rts5139: Fixed multi-line code alignment
  Staging: rts5139: Splitted one-line multiple assignment
  Staging: rts5139: Use standard pr_<level> prefixing
  Staging: rts5139: Removed OOM messages
  Staging: rts5139: More appropriate use of sizeof operand

 drivers/staging/rts5139/rts51x.c | 125 ++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 68 deletions(-)

-- 
1.9.1

