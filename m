Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3BDUIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:08:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:6958 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab3BDUIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:08:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="198602445"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Tejun Heo <tj@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "roland@kernel.org" <roland@kernel.org>
Subject: RE: [PATCHSET] idr: implement idr_alloc() and convert existing users
Thread-Topic: [PATCHSET] idr: implement idr_alloc() and convert existing
 users
Thread-Index: AQHOAwydQ2h2OImAJkq/KdAWqmA7TJhqHIQggAACahA=
Date: Mon, 4 Feb 2013 20:08:47 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D58DF86@FMSMSX108.amr.corp.intel.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130204191720.GW27963@mtj.dyndns.org> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like this kernel won't compile with CONFIG_HOTPLUG_MEMORY set to
> 'y'

Turning off the CONFIG_HOTPLUG_MEMORY allowed the build to work.

At least for me, basic IB functionality works with the latest repo.

The ipath and qib patches look ok, but we usually use IB/<module> vs. infiniband/<module>.

Mike
