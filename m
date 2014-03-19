Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaCSGYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:24:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:52880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbaCSGYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,683,1389772800"; 
   d="scan'208";a="502819693"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Thread-Index: AQHPQztoDV5ydIQ7XkyEAxRe0zKzqZrn8MCA
Date: Wed, 19 Mar 2014 06:23:55 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DB4940@HASMSX103.ger.corp.intel.com>
References: <20140319172035.b4e7c4043b486d8eeaa0534a@canb.auug.org.au>
In-Reply-To: <20140319172035.b4e7c4043b486d8eeaa0534a@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/net/wireless/iwlwifi/mvm/debugfs.c: In function
> 'iwl_dbgfs_fw_error_dump_release':
> drivers/net/wireless/iwlwifi/mvm/debugfs.c:161:2: error: implicit declaration
> of function 'vfree' [-Werror=implicit-function-declaration]
>   vfree(file->private_data);
>   ^

Sorry for that - patch on the way.

> 
> Caused by commit 1bd3cbc1a0e9 ("iwlwifi: mvm: send udev event upon
> firmware error to dump logs") from the wireless-next tree.  See Rule 1
> from Documentation/SubmitChecklist.
> 
> I have reverted that commit (and commit cdb00563fe2c ("iwlwifi: mvm: BT
> Coex - add debugfs hook to set BT Tx priority") that may depend on it)
> for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
