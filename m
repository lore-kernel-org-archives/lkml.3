Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaFCPiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:38:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40625 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaFCPiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:38:02 -0400
Date: Tue, 3 Jun 2014 08:37:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603153755.GO22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <20140602185635.GB13569@cloud>
 <20140602190821.GZ22231@linux.vnet.ibm.com>
 <20140602191155.GB13648@cloud>
 <20140602192729.GB22231@linux.vnet.ibm.com>
 <735924028.25620.1401740751632.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <735924028.25620.1401740751632.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060315-6688-0000-0000-0000024D24FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 08:25:51PM +0000, Mathieu Desnoyers wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
> > > On Mon, Jun 02, 2014 at 12:08:21PM -0700, Paul E. McKenney wrote:
> > > > On Mon, Jun 02, 2014 at 11:56:35AM -0700, josh@joshtriplett.org wrote:
> > > > > On Mon, Jun 02, 2014 at 11:16:58AM -0700, Paul E. McKenney wrote:
> > > > > > On Mon, Jun 02, 2014 at 10:59:28AM -0700, Joe Perches wrote:
> > > > > > > On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:

[ . . . ]

> > > > > For the record, I'd be happy to be listed as a co-maintainer for RCU.
> > > > > :)
> > > > 
> > > > I would be happy to put you down as maintainer and Steven down as
> > > > official reviewer.  ;-)
> > > 
> > > I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
> > > as reviewers as well, with their consent.
> > 
> > Mathieu, Oleg, Lai, any objections?
> 
> No objection from me. I'm always glad to help out
> reviewing RCU patches whenever I have some cycles
> available.

Very good!  I resent the series, replacing Dipankar with Josh as
co-maintainer, and adding Steven (perhaps prematurely) and Mathieu
as designated reviewers.

							Thanx, Paul

