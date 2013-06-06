Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3FFTqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:46:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62297 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3FFTqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:46:21 -0400
Date: Thu, 6 Jun 2013 12:46:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v5
 Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
 Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606194616.GA4928@core.coreip.homeip.net>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <20130606191847.GB4542@core.coreip.homeip.net>
 <CAPDwgkPdtj0Th8P+y9e5O7swARfzS40sG1A3Ba=pAmeXfMx0Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDwgkPdtj0Th8P+y9e5O7swARfzS40sG1A3Ba=pAmeXfMx0Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:40:47PM -0400, Yufeng Shen wrote:
> On Thu, Jun 6, 2013 at 3:18 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com>wrote:
> 
> > On Wed, Jun 05, 2013 at 06:36:53PM +0100, Nick Dyer wrote:
> > > The following patches are an updated series of patches to the
> > atmel_mxt_ts
> > > touch driver. They should apply cleanly to input/next.
> > >
> > > This is a combined patchset, I've been working to merge my changes with
> > the
> > > changes from the Chromium team. It's undergone a lot of testing and
> > review
> > > over the last few months and I believe it is now ready to go upstream.
> > >
> > > Most of these changes have been maintained and tested out-of-tree in
> > some form
> > > for a long time. I apologise for the backlog.
> > >
> > > We also provide a set of user-space utilities as open source which are
> > > available from github and work well with this driver:
> > >   https://github.com/atmel-maxtouch/obp-utils
> > >
> > > You can see the in-between versions at
> > >   https://github.com/ndyer/linux/
> > >
> >
> > Daniel, Henrik,
> >
> > Any comments befroe I start pulling parts of this in?
> >
> 
> 
> Can you hold this on for a few days ?  I would like to verify this patch
> series from chromium side.
> I probably would do it tomorrow and next monday and send back ack asap.

Sure, holding on is what I do best ;)

Thanks.

-- 
Dmitry
