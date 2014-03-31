Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaCaBVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 21:21:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:21011 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbaCaBVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 21:21:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,761,1389772800"; 
   d="scan'208";a="483661749"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Luck, Tony" <tony.luck@intel.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: RE: linux-next: build failure after merge of the ia64 tree
Thread-Topic: linux-next: build failure after merge of the ia64 tree
Thread-Index: AQHPTHVVvX4beeFQnE2J3+ULsG0e6Zr6ZixQ
Date: Mon, 31 Mar 2014 01:21:48 +0000
Message-ID: <144086DDB7BB6D429C79280EB1C804D40A79EB0C@SHSMSX104.ccr.corp.intel.com>
References: <20140331110756.c4f9b2e9f9f4874e0d90da11@canb.auug.org.au>
In-Reply-To: <20140331110756.c4f9b2e9f9f4874e0d90da11@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. We would fix it ASAP.

Yanmin

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Monday, March 31, 2014 8:08 AM
To: Luck, Tony
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, ShuoX; Zhang, Yanmin
Subject: linux-next: build failure after merge of the ia64 tree

Hi all,

After merging the ia64 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/built-in.o: In function `pstore_file_open':
inode.c:(.text+0xa29e9): undefined reference to `persistent_ram_size'

Caused by commit f5d7e81eda59 ("pstore: Support current records dump in ramoops").

I have used the ia64 tree from next-20140328 for today.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
