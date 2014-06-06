Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaFFPvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:51:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:10091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaFFPvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:51:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="543639353"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Topic: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Index: AQHPgRqYmzGw4rMJHUaHraTqiFbMAptjwnYAgABqpnCAAH16gIAAAgkA//+LAnCAAHgkAP//jFZg
Date: Fri, 6 Jun 2014 15:51:47 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A184656230FE@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
	 <1402068405.12513.5.camel@joe-AO725> <1402068842.12513.7.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465623059@ORSMSX105.amr.corp.intel.com>
 <1402069518.12882.5.camel@joe-AO725>
In-Reply-To: <1402069518.12882.5.camel@joe-AO725>
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

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, June 06, 2014 8:45 AM
> To: Allan, Bruce W
> Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> message size
> 
> On Fri, 2014-06-06 at 15:35 +0000, Allan, Bruce W wrote:
> > > 	Message size exceeding 100 000 characters causes blocking.
> > >
> > > But I believe that info is out of date.
> > >
> > If it is out of date, can you explain how/why we got stung by it?
> 
> Dunno.
> 
> Too many recipients maybe?
> 
> cc'ing more than 20 or so people can run up against
> that 1024 total byte header limit.
> 
> Maybe send me a copy of the original rejected posting?

Will-do, off-list.

