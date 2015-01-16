Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbbAPC2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:28:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:21816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbbAPC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:28:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,407,1418112000"; 
   d="scan'208";a="662701699"
Date: Fri, 16 Jan 2015 10:27:32 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Michael Halcrow <mhalcrow@google.com>
Cc: kbuild-all@01.org, "Theodore Ts'o" <tytso@mit.edu>,
        Uday Savagaonkar <savagaon@google.com>,
        Ildar Muslukhov <ildarm@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ext4:crypto 15/21] fs/ext4/crypto_fname.c:322:5: sparse: symbol
 'ext4_fname_decrypt' was not declared. Should it be static?
Message-ID: <201501161021.CZOoWii2%fengguang.wu@intel.com>
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
commit: 6b8813e5baf3aa99baec11610cc29bc4ed20e671 [15/21] ext4 crypto: filename encryption facilities
reproduce:
  # apt-get install sparse
  git checkout 6b8813e5baf3aa99baec11610cc29bc4ed20e671
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/crypto_fname.c:322:5: sparse: symbol 'ext4_fname_decrypt' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:380:5: sparse: symbol 'ext4_fname_encode_digest' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:479:6: sparse: symbol 'ext4_free_fname_crypto_ctx' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:532:30: sparse: symbol 'ext4_alloc_fname_crypto_ctx' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
