Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3K0HjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:39:22 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:24675 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K0HjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:39:21 -0500
From: Hariprasad S <hariprasad@chelsio.com>
To: "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felix Marti <felix@chelsio.com>
Subject: RE: pull request: linux-firmware: update cxgb4 firmware
Thread-Topic: pull request: linux-firmware: update cxgb4 firmware
Thread-Index: Ac7hF/dzZLJSa+FcRA24Y689Jws+aAKK2Q3d
Date: Wed, 27 Nov 2013 07:38:41 +0000
Message-ID: <26E3F92EC670BD429DB5CB319D773C13430211@nice.asicdesigners.com>
References: <26E3F92EC670BD429DB5CB319D773C1342B1E3@nice.asicdesigners.com>
In-Reply-To: <26E3F92EC670BD429DB5CB319D773C1342B1E3@nice.asicdesigners.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [111.93.129.158]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Nov 2013 07:38:42.0453 (UTC) FILETIME=[B2268C50:01CEEB43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

If you have not already pulled this, I will send out a new pull request which has update for both T4 and T5 firmware.

Thanks,
Hariprasad
________________________________
From: Hariprasad S
Sent: Thursday, November 14, 2013 2:30 PM
To: ben@decadent.org.uk; dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org; Felix Marti; Divy Le Ray
Subject: pull request: linux-firmware: update cxgb4 firmware


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
