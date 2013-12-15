Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3LOTcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:32:47 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:6068 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3LOTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:32:46 -0500
Date: Mon, 16 Dec 2013 01:02:21 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: <ben@decadent.org.uk>, <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <felix@chelsio.com>
Subject: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20131215193220.GA7536@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
X-OriginalArrivalTime: 15 Dec 2013 19:32:09.0719 (UTC) FILETIME=[58B47870:01CEF9CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please pull from the following URL?
    git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce824:
  Ben Hutchings (1):
          Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware

are available in the git repository at:

  git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

Hariprasad Shenai (1):
    cxgb4: Updated T4 firmware, add T5 firmware

 WHENCE                  |    8 +++++---
 cxgb4/t4fw-1.6.2.0.bin  |  Bin 431616 -> 0 bytes
 cxgb4/t4fw-1.9.23.0.bin |  Bin 0 -> 486912 bytes
 cxgb4/t4fw.bin          |    2 +-
 cxgb4/t5fw-1.9.23.0.bin |  Bin 0 -> 481280 bytes
 cxgb4/t5fw.bin          |    1 +
 6 files changed, 7 insertions(+), 4 deletions(-)
 delete mode 100644 cxgb4/t4fw-1.6.2.0.bin
 create mode 100644 cxgb4/t4fw-1.9.23.0.bin
 create mode 100644 cxgb4/t5fw-1.9.23.0.bin
 create mode 120000 cxgb4/t5fw.bin

Thanks,
Hariprasad Shenai
