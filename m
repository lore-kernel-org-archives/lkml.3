Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaFBS4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:56:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42308 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaFBS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:56:42 -0400
Date: Mon, 2 Jun 2014 11:56:35 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602185635.GB13569@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602181658.GX22231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 11:16:58AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 02, 2014 at 10:59:28AM -0700, Joe Perches wrote:
> > On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
> > > On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> > > > On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> > > > > A ksummit-discuss email thread looked at the difficulty recruiting
> > > > > and retaining reviewers.
> > > > 
> > > > []
> > > > 
> > > > > Paul Walmsley also noted the need for patch
> > > > > submitters to know who the key reviewers are and suggested adding an
> > > > > "R:" tag to the MAINTAINERS file to record this information on a
> > > > > per-subsystem basis.
> > > > 
> > > > I'm not sure of the value of this.
> > > > 
> > > > Why not just mark the actual reviewers as maintainers?
> > > 
> > > As discussed in the kernel summit discussion, being a regular patch
> > > reviewer isn't the same thing as being *the* maintainer.
> > 
> > I think it's not particularly important or valuable
> > here to make that distinction.
> > 
> > What real difference does it make?
> 
> In the particular case of Josh, none, at least from my viewpoint.  He of
> course might or might not want to take on additional maintainership
> responsibility at this particular point in time, in which case, I would
> be more than happy to have him as a designated maintainer.

For the record, I'd be happy to be listed as a co-maintainer for RCU. :)

- Josh Triplett
