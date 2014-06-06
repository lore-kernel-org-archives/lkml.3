Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaFFPgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:36:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:15521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaFFPgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:36:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="524060113"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Topic: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Index: AQHPgRqYmzGw4rMJHUaHraTqiFbMAptjwnYAgABqpnCAAH16gIAAAgkA//+LAnA=
Date: Fri, 6 Jun 2014 15:35:58 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18465623059@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
	 <1402068405.12513.5.camel@joe-AO725> <1402068842.12513.7.camel@joe-AO725>
In-Reply-To: <1402068842.12513.7.camel@joe-AO725>
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
> Sent: Friday, June 06, 2014 8:34 AM
> To: Allan, Bruce W
> Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> message size
> 
> On Fri, 2014-06-06 at 08:26 -0700, Joe Perches wrote:
> > On Fri, 2014-06-06 at 15:08 +0000, Allan, Bruce W wrote:
> > > From: Joe Perches [mailto:joe@perches.com]
> > > Sent: Thursday, June 05, 2014 6:36 PM
> > > > On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> > > > > the maximum message size (100,000 characters) allowed by
> Majordomo at
> > > > > vger.kernel.org since that is where most Linux email lists are served.
> > > > I believe this is incorrect and the patch is unnecessary.
> > > Actually, it is correct (it even says so at
> http://vger.kernel.org/majordomo-info.html).
> > where?
> 
> Duh, near the very end it does have:
> 
> 	Message size exceeding 100 000 characters causes blocking.
> 
> But I believe that info is out of date.
> 

If it is out of date, can you explain how/why we got stung by it?

