Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbbAOQb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:31:58 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:34983 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbAOQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:31:56 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:24 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Staging: vt6655: Fix style and checkpatch issues 
Date: Fri, 16 Jan 2015 03:29:20 +1100
Message-Id: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch and formatting issues in drivers/staging/vt6655/mac.h

Emrys Bayliss (7):
  Staging: vt6655: Checkpatch fix: unnecessary whitespace
  Staging: vt6655: Checkpatch fix: empty c99 comments
  Staging: vt6655: comment after statement formatting
  Staging: vt6655: Checkpatch fix: c99 comments after statements
  Staging: vt6655: Checkpatch fix: lines longer than 80 columns
  Staging: vt6655: comment headings formatting
  Staging: vt6655: Checkpatch fix: c99 comment headings

 drivers/staging/vt6655/mac.h | 684 ++++++++++++++++++++-----------------------
 1 file changed, 317 insertions(+), 367 deletions(-)

-- 
2.2.1

