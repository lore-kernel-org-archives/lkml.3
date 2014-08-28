Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaH1Vjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:39:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:32958 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaH1Vju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:39:50 -0400
Date: Thu, 28 Aug 2014 14:39:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
Message-ID: <20140828213945.GP5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
 <53FF8B77.7000103@infradead.org>
 <20140828210010.GM5001@linux.vnet.ibm.com>
 <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082821-0928-0000-0000-0000047BB590
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 05:15:50PM -0400, Pranith Kumar wrote:
> On Thu, Aug 28, 2014 at 5:00 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > I am really confused by the ordering of the new lines, as I would have
> > expected the "x"s to be replaced with "y"s and vice versa.  But the
> > ordering of the various combinations does not matter, and each line
> > looks OK.
> 
> Since x = A was replaced by x = B and y = B was replaced by y = A, I
> just converted all x = load A to x = load B. Similarly for y. I think
> we can do either this or as you suggested replacing x's with y's.

Fair enough.  The other thing that confused me was the "STORE B=4,"
showing up early in your replacement.

							Thanx, Paul

