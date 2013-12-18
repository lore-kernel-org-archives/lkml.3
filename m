Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3LRCyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:54:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:5157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab3LRCyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:54:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,504,1384329600"; 
   d="scan'208";a="426378655"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: RE: linux-next: build warning in Linus' tree
Thread-Topic: linux-next: build warning in Linus' tree
Thread-Index: AQHO+3sJv7Hxk+uDHkOiaiqJHf11XppZQP2A
Date: Wed, 18 Dec 2013 02:54:37 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF2228664685D5839F@ORSMSX110.amr.corp.intel.com>
References: <20131218095203.aceb7cfffffa16907feb9af7@canb.auug.org.au>
In-Reply-To: <20131218095203.aceb7cfffffa16907feb9af7@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Stephen Rothwell
> Sent: Tuesday, December 17, 2013 2:52 PM
> To: David Miller; netdev@vger.kernel.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Fastabend,
> John R; Neil Horman
> Subject: linux-next: build warning in Linus' tree
> 
> Hi all,
> 
> While building Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c: In function
> 'ixgbe_pci_sriov_disable':
> drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c:294:6: warning: unused
> variable 'current_flags' [-Wunused-variable]
>   u32 current_flags = adapter->flags;
>       ^
> 
> Introduced by commit 2a47fa45d4df ("ixgbe: enable l2 forwarding
> acceleration for macvlans") which was merged before v3.13-rc1.
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


Hey Stephen,

Thanks for letting us know about this.   As it turns out we already have a patch to fix this in our internal tree (Jeff K's) just waiting final validation.  It shouldn't be long before he submits it.

Thanks again,
-Don Skidmore <donald.c.skidmore@intel.com>

