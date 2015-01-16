Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbbAPCHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:07:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:8057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbbAPCHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:07:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,407,1418112000"; 
   d="scan'208";a="638078391"
Date: Fri, 16 Jan 2015 10:07:13 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Michael Halcrow <mhalcrow@google.com>
Cc: kbuild-all@01.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ext4:crypto 8/21] fs/ext4/xattr_encryption.c:80:5: sparse: symbol
 'ext4_xattr_encryption_context_set' was not declared. Should it be static?
Message-ID: <201501161001.0s7ByimN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git crypto
head:   e32261a72a3c0c6c59d761820d8ca8b7c90008af
commit: db813a4cea85922497d58e94304d75517576af03 [8/21] ext4 crypto: add encryption xattr support
reproduce:
  # apt-get install sparse
  git checkout db813a4cea85922497d58e94304d75517576af03
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/xattr_encryption.c:80:5: sparse: symbol 'ext4_xattr_encryption_context_set' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
