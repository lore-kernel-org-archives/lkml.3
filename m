Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaBTMvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:51:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:1716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaBTMvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208";a="486547579"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] net: rfkill: gpio: clean up and a few new acpi ids
Date: Thu, 20 Feb 2014 14:51:33 +0200
Message-Id: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was waiting for the DT support from Chen-Yu before sending these,
but decided it makes no difference when I send them. I'm dropping the
con ID in the second patch because Dan noticed the warning, but of
course it will mean the "gpios" property can be used with DT.

The two last patches just add ACPI IDs for some new Baytrail based
boards.


Heikki Krogerus (4):
  net: rfkill: gpio: remove unused and obsolete platform parameters
  net: rfkill: gpio: remove gpio names
  net: rfkill: gpio: add ACPI ID for GPS module on Lenove Miix2
  net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip

 include/linux/rfkill-gpio.h | 10 ----------
 net/rfkill/rfkill-gpio.c    | 38 +++++++-------------------------------
 2 files changed, 7 insertions(+), 41 deletions(-)

-- 
1.9.0.rc3

