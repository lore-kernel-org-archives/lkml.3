Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3DATFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:05:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:38690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab3DATFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="287807247"
From: "Love, Robert W" <robert.w.love@intel.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "Bhanu (Venkata Bhanu Prakash) Gollapudi" <bprakash@broadcom.com>
Subject: fcoe pull-request 3.9-rc5
Thread-Topic: fcoe pull-request 3.9-rc5
Thread-Index: AQHOLwvj4ZshInu/i0CLktU3g5QSSw==
Date: Mon, 1 Apr 2013 19:05:35 +0000
Message-ID: <5159DA7E.7070606@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B3EB16E883FD214CB27E7F87404176F4@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

   Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/for-3.9-rc

for you to fetch changes up to 0db0e377ab5be5d507a2fca3d78215cd2e83b974:

   libfcoe: Fix fcoe_sysfs VN2VN mode (2013-03-25 16:04:22 -0700)

----------------------------------------------------------------
Critical patches to fix FCoE VN2VN mode with new interfaces targeting 3.9-rc

----------------------------------------------------------------
Robert Love (5):
       bnx2fc: Make the fcoe_cltr the SCSI host parent
       fcoe: Fix deadlock between create and destroy paths
       libfc, fcoe, bnx2fc: Always use fcoe_disc_init for discovery 
layer initialization
       libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init, config}
       libfcoe: Fix fcoe_sysfs VN2VN mode

  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 ++--
  drivers/scsi/fcoe/fcoe.c          |   15 +++++++---
  drivers/scsi/fcoe/fcoe_ctlr.c     |   60 
++++++++++++++++++++++++++++---------
  drivers/scsi/libfc/fc_disc.c      |   26 +++++++++++-----
  include/scsi/libfc.h              |    3 +-
  5 files changed, 80 insertions(+), 30 deletions(-)

