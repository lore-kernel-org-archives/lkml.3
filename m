Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaEEQDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:03:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38158 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaEEQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:03:21 -0400
Date: Mon, 5 May 2014 09:03:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Did you still need asynchronous grace-period detection?
Message-ID: <20140505160316.GL8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140502235355.GA13710@linux.vnet.ibm.com>
 <20140505134554.GP26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505134554.GP26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050516-6688-0000-0000-00000195FF3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 03:45:54PM +0200, Peter Zijlstra wrote:
> On Fri, May 02, 2014 at 04:53:56PM -0700, Paul E. McKenney wrote:
> > Hello, Peter,
> > 
> > The following commit seems to have been dropped on the floor.
> > Given that you haven't complained, I feel the need to ask you
> > if you still need it.  ;-)
> > 
> > If you do need it, I will push it into 3.16.
> 
> Yes, I do.. thanks for reminding me, I'll need to go find the patch that
> needs it :-)

No problem!

And it turns out that it is in fact in mainline.  I was looking at
an obsolete patch, thus looking in the wrong place for it.  :-/

Good thing I didn't try to add it again...

							Thanx, Paul

