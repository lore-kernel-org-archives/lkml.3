Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaJUIHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:07:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:16492 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaJUIF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:28 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <nicolas.ferre@atmel.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/2] *** jffs2: fix debug outputs ***
Date: Tue, 21 Oct 2014 10:04:58 +0200
Message-ID: <cover.1413878259.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches fixes some bugs in the output of jffs2 debug functions.

Cyrille Pitchen (2):
  jffs2: fix wrong offset in an error msg from
    __jff2_dbg_prewrite_paranoia_check
  jffs2: fix buffer dump debug output

 fs/jffs2/debug.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

-- 
1.8.2.2

