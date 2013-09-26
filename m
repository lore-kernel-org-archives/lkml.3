Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3IZWJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:09:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:6230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3IZWJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,988,1371106800"; 
   d="scan'208";a="407783158"
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: Joe Perches <joe@perches.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
Thread-Topic: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
Thread-Index: AQHOuikpWSwakwktDEaRN9nugJ6x8pnXV2cAgAAlbYCAANX8oIAAtgAA//+MciA=
Date: Thu, 26 Sep 2013 22:09:32 +0000
Message-ID: <3A78FAA0EC814D4B8ECC99B3AB32B3321637554A@FMSMSX102.amr.corp.intel.com>
References: <1380138892.17366.24.camel@joe-AO722>
	 <20130925200950.GA10751@redhat.com> <1380147827.17366.25.camel@joe-AO722>
	 <3A78FAA0EC814D4B8ECC99B3AB32B33216375160@FMSMSX102.amr.corp.intel.com>
 <1380232864.17366.84.camel@joe-AO722>
In-Reply-To: <1380232864.17366.84.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
> 
> On Thu, 2013-09-26 at 18:11 +0000, Perez-Gonzalez, Inaky wrote:
> > > From: Joe Perches [mailto:joe@perches.com]
> > > >
> > > > The W: link is dead.
> > > >
> > > > Given wimax never really took off, is there any point in keeping this in
> the kernel at all ?
> > > > We turned off the drivers in Fedora a while ago, and just threw out the
> userspace parts.
> > > > I wouldn't be surprised to learn of other distributions doing the same.
> > >
> > > Inaky?
> > > Are you doing any work on this at all?
> > > Should this be deleted?
> >
> > I do minimal maintenance, which in the last two years has been close to
> zero.
> >
> > I do get, however, occasional support requests (serviced as time
> > permits) from South America and Russia, which makes me think they use
> > it. How much, I don't know.
> >
> > Unless it is a pain, I'd keep it there
> 
> I think you should take the initial MAINTAINERS patch that marks the mailing
> lists as subscribers-only.
> 
> I don't subscribe and got useless bounces.

ACK--do I need to  do it and can the patch go straight to the tree?
