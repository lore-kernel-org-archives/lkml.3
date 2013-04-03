Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700Ab3DCRIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:08:17 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61364 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762550Ab3DCRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:08:14 -0400
Date: Wed, 3 Apr 2013 10:08:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: William Dauchy <wdauchy@gmail.com>, Jan Beulich <JBeulich@suse.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Ian Campbell <ian.campbell@citrix.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
Message-ID: <20130403170812.GA24633@kroah.com>
References: <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
 <1362306002.1334.29.camel@x61.thuisdomein>
 <5134617F02000078000C2AD8@nat28.tlf.novell.com>
 <1362388302.16460.5.camel@x61.thuisdomein>
 <5134741702000078000C2B3E@nat28.tlf.novell.com>
 <20130304150246.GA15794@phenom.dumpdata.com>
 <20130312221030.GB27330@kroah.com>
 <CAJ75kXZDTpJUnKp+UJ+3kib9Wog0yRgXn1m+DDgHaMwr=1=4UA@mail.gmail.com>
 <20130403160106.GA28914@kroah.com>
 <20130403163828.GB11926@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403163828.GB11926@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 12:38:28PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 03, 2013 at 09:01:06AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Apr 03, 2013 at 04:01:54PM +0200, William Dauchy wrote:
> > > On Tue, Mar 12, 2013 at 11:10 PM, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >> > >> IOW I don't see why this got proposed for stable at all.
> > > >> > >
> > > >> > > So, you suggest to just drop this patch for v3.8.3, don't you?
> > > >> >
> > > >> > I do, yes. But I'd suggest to get Konrad to agree.
> > > >>
> > > >> Yes. Lets drop it.
> > > >
> > > > Now reverted, thanks.
> > > 
> > > Seems like still present in 3.4.x branch. Is that a mistake?
> > 
> > It showed up in 3.4.35, if that's a mistake, and I should revert it,
> > please, someone let me know.
> 
> Yes. It is a mistake. Please revert it.

Now reverted, thanks.

greg k-h
