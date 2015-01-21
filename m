Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbbAUXfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:35:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:15253 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbbAUXev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:34:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,444,1418112000"; 
   d="scan'208";a="665505011"
Date: Thu, 22 Jan 2015 07:34:04 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [PATCH ext3] quota: qtype_enforce_flag() can be static
Message-ID: <20150121233404.GA126865@lkp-sb04>
References: <201501220757.KwzDB2MB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501220757.KwzDB2MB%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/quota/quota.c:69:14: sparse: symbol 'qtype_enforce_flag' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index a5b7c35..7283117 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -66,7 +66,7 @@ static int quota_sync_all(int type)
 	return ret;
 }
 
-unsigned int qtype_enforce_flag(int type)
+static unsigned int qtype_enforce_flag(int type)
 {
 	switch (type) {
 	case USRQUOTA:
