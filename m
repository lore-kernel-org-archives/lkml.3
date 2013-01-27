Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3A0Ace (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:32:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:15930 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3A0Acc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:32:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="195490257"
Date: Sun, 27 Jan 2013 01:32:29 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Harald Welte <laforge@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: pcf50633: Init pcf->dev before using it
Message-ID: <20130127003229.GG1174@sortiz-mobl>
References: <1356403969.22368.1.camel@phoenix>
 <20130122033105.GX7409@sortiz-mobl>
 <CAFRkauDQD4bA2VwrWVfzBcwY-A7y4VzQam8tB4L5HGNOS48uGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRkauDQD4bA2VwrWVfzBcwY-A7y4VzQam8tB4L5HGNOS48uGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Jan 25, 2013 at 11:08:00AM +0800, Axel Lin wrote:
> 2013/1/22 Samuel Ortiz <sameo@linux.intel.com>
> 
> > Hi Axel,
> >
> > On Tue, Dec 25, 2012 at 10:52:49AM +0800, Axel Lin wrote:
> > > Current code uses pcf->dev in the dev_err call before setting it to
> > > &client->dev. Fix it.
> > >
> > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > > ---
> > >  drivers/mfd/pcf50633-core.c |    5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > Applied to my for-linus branch, thanks.
> >
> 
> Hi Samuel,
> Seems the patches queued in your for-linus branch does not (yet) appear in
> linux-next?
for-linus goes to Linus and then they show up in linux-next.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
