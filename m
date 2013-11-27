Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3K0ILs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:11:48 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:1100 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3K0ILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:11:42 -0500
Date: Wed, 27 Nov 2013 13:45:06 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: <ben@decadent.org.uk>, <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <felix@chelsio.com>
Subject: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20131127081505.GB7998@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
X-OriginalArrivalTime: 27 Nov 2013 08:10:45.0295 (UTC) FILETIME=[2C40F3F0:01CEEB48]
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

 cxgb4/t4fw-1.6.2.0.bin  |  Bin 431616 -> 0 bytes
 cxgb4/t4fw-1.8.24.0.bin |  Bin 0 -> 479744 bytes
 cxgb4/t4fw.bin          |    2 +-
 cxgb4/t5fw-1.8.28.0.bin |  Bin 0 -> 462848 bytes
 cxgb4/t5fw.bin          |    1 +
 5 files changed, 2 insertions(+), 1 deletions(-)
 delete mode 100644 cxgb4/t4fw-1.6.2.0.bin
 create mode 100644 cxgb4/t4fw-1.8.24.0.bin
 create mode 100644 cxgb4/t5fw-1.8.28.0.bin
 create mode 120000 cxgb4/t5fw.bin
