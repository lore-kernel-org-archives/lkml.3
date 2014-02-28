Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaB1Toe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:44:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaB1Tod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:44:33 -0500
Date: Fri, 28 Feb 2014 14:44:22 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 11/19] perf, c2c: Add in sort on physid
Message-ID: <20140228194422.GL25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-12-git-send-email-dzickus@redhat.com>
 <87ppm7aws9.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppm7aws9.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:59:18AM -0800, Andi Kleen wrote:
> Don Zickus <dzickus@redhat.com> writes:
> > +
> > +	/*
> > +	 * must pass period=weight in order to get the correct
> > +	 * sorting from hists__collapse_resort() which is solely
> > +	 * based on periods. We want sorting be done on nr_events * weight
> > +	 * and this is indirectly achieved by passing period=weight here
> > +	 * and the he_stat__add_period() function.
> > +	 */
> 
> sort.c really must be fixed to support multiple sort keys properly.
> Lots of other code has workarounds for this too (e.g. it is a bit
> problem for TSX abort weights)
> 
> I would suggest to fix that instead of hacking around it.

I don't think I understand the problem enough to know what to fix.  I just
copied this piece of code from builtin-report.c and things seemed to work.

Mind giving me some details and I can look at fixing it. :-)

Cheers,
Don
