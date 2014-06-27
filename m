Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaF0Mz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:55:29 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:20892
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752604AbaF0Mz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:55:27 -0400
X-Greylist: delayed 2968 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 08:55:27 EDT
Date: Fri, 27 Jun 2014 17:39:11 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: <linux-firmware@kernel.org>
CC: <ben@decadent.org.uk>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20140627120910.GA2406@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please pull from the following URL?
    git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

The following changes since commit 7f388b4885cf64d6b7833612052d20d4197af96f:
Ben Hutchings (1):
    Move the s5p-mfc firmware out of its subdirectory

are available in the git repository at:

git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

Hariprasad Shenai (1):
    cxgb4: Update firmware to revision 1.11.27.0

    LICENCE.chelsio_firmware |    2 +-
    WHENCE                   |    8 ++++----
    cxgb4/t4fw-1.11.27.0.bin |  Bin 0 -> 512512 bytes
    cxgb4/t4fw-1.9.23.0.bin  |  Bin 486912 -> 0 bytes
    cxgb4/t4fw.bin           |    2 +-
    cxgb4/t5fw-1.11.27.0.bin |  Bin 0 -> 513024 bytes
    cxgb4/t5fw-1.9.23.0.bin  |  Bin 481280 -> 0 bytes
    cxgb4/t5fw.bin           |    2 +-
    8 files changed, 7 insertions(+), 7 deletions(-)
    create mode 100644 cxgb4/t4fw-1.11.27.0.bin
    delete mode 100644 cxgb4/t4fw-1.9.23.0.bin
    create mode 100644 cxgb4/t5fw-1.11.27.0.bin
    delete mode 100644 cxgb4/t5fw-1.9.23.0.bin
