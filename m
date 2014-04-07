Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaDGU2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:28:02 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62644 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDGU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:28:00 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v2 0/5] Staging: rts5139: Fix coding style
Date: Mon,  7 Apr 2014 22:27:43 +0200
Message-Id: <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140407003341.GA13365@kroah.com>
References: <20140407003341.GA13365@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style issues in rts51x.c (from rts5139 module).
This is for task 10 of the Eudyptula challenge.

Fabio Falzoi (5):
  Camel case labels replaced
  Fixed multi-line code alignment
  Splitted one-line multiple assignment
  pr_warn(...) in place of printk(KERN_WARNING ...)
  More appropriate sizeof operand

 drivers/staging/rts5139/rts51x.c | 62 ++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

-- 
1.9.1

