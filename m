Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3HTUON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:14:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751061Ab3HTUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:14:11 -0400
Message-ID: <1377029650.2016.72.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Tue, 20 Aug 2013 13:14:10 -0700
In-Reply-To: <1377028944.2737.75@driftwood>
References: <1376944033.2016.13.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
	 <1376946644.2016.35.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
	 <1376947637.2016.39.camel@joe-AO722> <1377028944.2737.75@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 15:02 -0500, Rob Landley wrote:
> On 08/19/2013 04:27:17 PM, Joe Perches wrote:
> > On Mon, 2013-08-19 at 23:22 +0200, Jiri Kosina wrote:
> > > On Mon, 19 Aug 2013, Joe Perches wrote:
> > >
> > > > This is a 7 line patch that corrects logging defects that has had  
> > no
> > > > reply from you for the last month.
> > > >
> > > > https://patchwork.kernel.org/patch/2833648/
> > >
> > > This hasn't missed any Linus' major release, as it has been  
> > submitted post
> > > 3.11 merge, right? (hint, that was Jul 4th).
> > >
> > > If this would miss *next* major Linus' release, I would accept your
> > > complaints. But this is definitely not the case.
> > 
> > You're suggesting this patch, which corrects obvious
> > defects, should miss 3.12 and go into 3.13?
> > 
> > I think that's wrong.
> 
> Correcting obvious defects, which can't wait a release, is "trivial"  
> now, is it?

Rob, how do you suggest this obvious and trivial
patch be handled?

Send 6+ 1 line patches that do the same thing to
individual maintainers?

The next release in a couple/few weeks is 3.11.
3.12 should take 2.5/3 months for a typical cycle.

Patches bound for 3.12 should be in -next today.

3.13 should be out in about half a year.

Is it really appropriate to delay the trivially
obvious for sixish months?


