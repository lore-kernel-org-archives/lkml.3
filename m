Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaFBUaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:30:01 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57293 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:30:00 -0400
Date: Mon, 2 Jun 2014 13:29:53 -0700
From: josh@joshtriplett.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602202953.GA14013@cloud>
References: <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <20140602185635.GB13569@cloud>
 <20140602190821.GZ22231@linux.vnet.ibm.com>
 <20140602191155.GB13648@cloud>
 <20140602192729.GB22231@linux.vnet.ibm.com>
 <1401737782.7323.31.camel@joe-AO725>
 <538CD336.4080103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CD336.4080103@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:40:38PM -0700, Randy Dunlap wrote:
> On 06/02/2014 12:36 PM, Joe Perches wrote:
> > On Mon, 2014-06-02 at 12:27 -0700, Paul E. McKenney wrote:
> >> On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
> >>>
> >>> I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
> >>> as reviewers as well, with their consent.
> >>
> >> Mathieu, Oleg, Lai, any objections?
> > 
> > I suggest not going overboard with R entries.
> > If there are more than 1 or 2, create a mailing list.
> 
> Yes, much better on the patch sender(s) to Cc: 1 or 2 people or lists
> than to have to copy/paste 5 or 6 email addresses.

A patch sender should never need to manually copy and paste email
addresses, given get_maintainer.pl.

- Josh Triplett
