Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaFFPfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:35:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:47313 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaFFPfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="543632535"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Topic: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Index: AQHPgRqYmzGw4rMJHUaHraTqiFbMAptjwnYAgABqpnCAAH16gP//jBKg
Date: Fri, 6 Jun 2014 15:35:02 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1846562304A@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
 <1402068405.12513.5.camel@joe-AO725>
In-Reply-To: <1402068405.12513.5.camel@joe-AO725>
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
> Sent: Friday, June 06, 2014 8:27 AM
> To: Allan, Bruce W
> Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> message size
> 
> On Fri, 2014-06-06 at 15:08 +0000, Allan, Bruce W wrote:
> > > -----Original Message-----
> > > From: Joe Perches [mailto:joe@perches.com]
> > > Sent: Thursday, June 05, 2014 6:36 PM
> > > To: Allan, Bruce W
> > > Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> > > Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> > > message size
> > >
> > > On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> > > > the maximum message size (100,000 characters) allowed by
> Majordomo at
> > > > vger.kernel.org since that is where most Linux email lists are served.
> > >
> > > I believe this is incorrect and the patch is unnecessary.
> >
> > Actually, it is correct (it even says so at
> http://vger.kernel.org/majordomo-info.html).
> 
> where?
> 
> All it says there that's relevant is:
> 
> ------------------------------------------
> All email sent to there must be TEXT/PLAIN, there can be no multipart
> messages, no VCARDs, nothing ``fancy''. In presence of such things,
> Majordomo will very likely do the wrong thing.
> 
> When you send there email, do make sure that all of the email headers,
> both visible and transport level, have same addresses in them. People
> experience problems when for example ``From:'', ``Sender:'' and possible
> ``Reply-To:'' headers present different addresses. The most common
> manifestation is complete silence from VGER!
> ------------------------------------------
> 

http://vger.kernel.org/majordomo-info.html#taboo says:
The Majordomo is configured with a set of filter rules which when triggered will send
the email to "/dev/null". 
(List owner actually, but they are overworked elsewere, and use "d" button usually...)
<snip>
* Message size exceeding 100 000 characters causes blocking.


> > We just experienced 2 out of 4 patches in the initial RFC submittal of the
> Intel(R)
> > QuickAssist Technology (QAT) driver being blocked by Majordomo from
> getting out
> > on the linux-crypto mailing list.
> 
> Possible, but the largest patch I've seen recently
> on linux-kernel is about .5 Meg, 5 times your limit.
> 
> >   It took a while to figure out the problem and had to
> > break up those two blocked patches into smaller ones which went
> through fine.  I
> > submitted this checkpatch patch in hopes to prevent others from having
> to figure out
> > the same.
> 
> Maybe specific to crypto?
> 
> > > It'd maybe more interesting if the email header sizes
> > > were calculated and if > 1024, then some bleating message
> > > were emitted.
> 
> This specific bit, email headers > 1K in total size,
> is an actual failure mode btw.

