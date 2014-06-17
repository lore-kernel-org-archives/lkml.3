Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaFQJMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:12:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:1279 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbaFQJL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,493,1400050800"; 
   d="scan'208";a="549095882"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/2] fix for --param GCC's command line option
Date: Tue, 17 Jun 2014 12:11:44 +0300
Message-Id: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a dumb fix to avoid --param option and make sparse survive.

Since v1:
 - added patch 1/2
 - handle both --param=* and --param *

Andy Shevchenko (2):
  lib.c: introduce split_value_from_arg helper
  lib.c: skip --param parameters

 lib.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

-- 
2.0.0

