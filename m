Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbaD2RpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:45:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52007 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326AbaD2RpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:45:14 -0400
Date: Tue, 29 Apr 2014 10:45:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140429174508.GI8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140427062650.GW4496@linux.vnet.ibm.com>
 <20140428135540.GA14661@linux.vnet.ibm.com>
 <535E8D14.7080405@infradead.org>
 <535E8E17.2050600@nod.at>
 <20140428200640.GG4430@linux.vnet.ibm.com>
 <535EBAE6.3080907@infradead.org>
 <20140428211535.GK4430@linux.vnet.ibm.com>
 <535F95FC.1020909@redhat.com>
 <20140429163604.GH8754@linux.vnet.ibm.com>
 <535FE1DB.2060601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FE1DB.2060601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042917-0928-0000-0000-00000191AE4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 01:31:07PM -0400, Rik van Riel wrote:
> On 04/29/2014 12:36 PM, Paul E. McKenney wrote:
> > On Tue, Apr 29, 2014 at 08:07:24AM -0400, Rik van Riel wrote:
> >> On 04/28/2014 05:15 PM, Paul E. McKenney wrote:
> >>> On Mon, Apr 28, 2014 at 01:32:38PM -0700, Randy Dunlap wrote:
> >>>> On 04/28/14 13:06, Paul E. McKenney wrote:
> >>
> >>>>> Please see below for a patch against next-20140428 that makes this build
> >>>>> for me.  This is derived from Rik's patch, my patch, and is consistent with
> >>>>> Arnd's patch.
> >>>>>
> >>>>> 							Thanx, Paul
> >>>>
> >>>> Thnx, works for me.  Finally.
> >>>
> >>> Good!
> >>>
> >>> Rik, how would you like to proceed with this?
> >>
> >> I guess this fix should go into -mm?
> > 
> > Andrew dropped the original patch, so a consolidated patch is needed.
> > I believe that something like the following is what we ended up with.
> > Does this look right to you?
> 
> That looks exactly like the one I have here :)

That is reassuring.  ;-)

							Thanx, Paul

> Andrew, should I send you the two patches?
> 
> -- 
> All rights reversed
> 

