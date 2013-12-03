Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3LCTBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:01:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:58235 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3LCTA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,819,1378882800"; 
   d="scan'208";a="446195784"
From: "Luck, Tony" <tony.luck@intel.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
CC: xen-devel <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: IA64 on Xen support
Thread-Topic: IA64 on Xen support
Thread-Index: AQHO8FM1rVEPgt3rWUqyz77XAhhAKZpC0vwg
Date: Tue, 3 Dec 2013 19:00:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D7D0ED@ORSMSX106.amr.corp.intel.com>
References: <529E1F47.50107@oracle.com>
In-Reply-To: <529E1F47.50107@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure - the bits there worked once - but have been stale for several releases.  With nobody actively
supporting this things will only get worse.

-Tony

-----Original Message-----
From: Boris Ostrovsky [mailto:boris.ostrovsky@oracle.com] 
Sent: Tuesday, December 03, 2013 10:13 AM
To: Luck, Tony; Yu, Fenghua
Cc: xen-devel; linux-kernel@vger.kernel.org
Subject: IA64 on Xen support

Tony, Fenghua,


We had a discussion at the last Xen Summit about status of Linux' IA64 
Xen. Xen itself dropped IA64 support in 4.2 (it is approaching 4.4 now) 
and it's not clear whether we can even build Linux/Xen/IA64 against 
latest Xen sources, let alone run it.

The proposal at the summit was to remove Xen-related bits from IA64 in 
Linux. Any objections to this?


Thanks.
-boris


