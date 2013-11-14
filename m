Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3KNJym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:54:42 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:31673 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3KNJyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:54:39 -0500
X-Greylist: delayed 3187 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2013 04:54:38 EST
From: Hariprasad S <hariprasad@chelsio.com>
To: "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felix Marti <felix@chelsio.com>, Divy Le Ray <divy@chelsio.com>
Subject: pull request: linux-firmware: update cxgb4 firmware
Thread-Topic: pull request: linux-firmware: update cxgb4 firmware
Thread-Index: Ac7hF/dzZLJSa+FcRA24Y689Jws+aA==
Date: Thu, 14 Nov 2013 09:00:50 +0000
Message-ID: <26E3F92EC670BD429DB5CB319D773C1342B1E3@nice.asicdesigners.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.167.16.81]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Nov 2013 09:00:52.0077 (UTC) FILETIME=[0510B9D0:01CEE118]
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
      cxgb4: add t5fw-1.8.28.0.bin firmware

 cxgb4/t5fw-1.8.28.0.bin |  Bin 0 -> 462848 bytes
 cxgb4/t5fw.bin          |    1 +
 2 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 cxgb4/t5fw-1.8.28.0.bin
 create mode 120000 cxgb4/t5fw.bin
