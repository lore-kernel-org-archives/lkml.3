Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3GXNYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:24:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:31428 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3GXNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,735,1367996400"; 
   d="scan'208";a="336062299"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3] mei reset cleanups
Date: Wed, 24 Jul 2013 16:22:56 +0300
Message-Id: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some more reset cleanups, less urgent then 
the series that went for 3.11

And fix for one non likely to happen security issue


Tomas Winkler (3):
  mei: wake also writers on reset
  mei: don't get stack in select during reset
  mei: bus: do not overflow the device name buffer

 drivers/misc/mei/amthif.c | 14 +++++++++++---
 drivers/misc/mei/bus.c    |  4 ++--
 drivers/misc/mei/client.c | 15 ++++++++-------
 drivers/misc/mei/client.h |  9 ++++++++-
 drivers/misc/mei/init.c   | 13 ++++++++-----
 drivers/misc/mei/main.c   | 22 +++++++++++++++-------
 6 files changed, 52 insertions(+), 25 deletions(-)

-- 
1.8.1.2

