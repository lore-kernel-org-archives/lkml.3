Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbbAXAek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:34:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:9970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbAXAef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:34:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,457,1418112000"; 
   d="scan'208";a="516875246"
Date: Sat, 24 Jan 2015 08:33:40 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Michael Halcrow <mhalcrow@google.com>
Cc: kbuild-all@01.org, "Theodore Ts'o" <tytso@mit.edu>,
        Uday Savagaonkar <savagaon@google.com>,
        Ildar Muslukhov <ildarm@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ext4:crypto 17/19] fs/ext4/namei.c:2056:5: sparse: symbol
 'ext4_find_dest_de_crypt' was not declared. Should it be static?
Message-ID: <201501240824.lsZlTlwQ%fengguang.wu@intel.com>
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
head:   dfc8aa97bd527d156f6e7ee3f0286af2229be45d
commit: 2842df91db1447a594331116ee48fbf4647b3dd0 [17/19] ext4 crypto: filename encryption modifications
reproduce:
  # apt-get install sparse
  git checkout 2842df91db1447a594331116ee48fbf4647b3dd0
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/namei.c:2056:5: sparse: symbol 'ext4_find_dest_de_crypt' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
