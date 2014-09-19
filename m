Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaISQGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:06:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59702 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaISQGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:06:01 -0400
Date: Fri, 19 Sep 2014 09:05:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Move BTRFS RCU string to common library
Message-ID: <20140919160555.GD4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1411116672.git.osandov@osandov.com>
 <20140919154546.GZ4723@linux.vnet.ibm.com>
 <541C5029.1070500@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541C5029.1070500@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091916-3532-0000-0000-000004C6E0FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:47:53AM -0400, Chris Mason wrote:
> 
> 
> On 09/19/2014 11:45 AM, Paul E. McKenney wrote:
> > On Fri, Sep 19, 2014 at 02:01:28AM -0700, Omar Sandoval wrote:
> >> This patch series moves the generic RCU string library used internally by BTRFS
> >> to be accessible by anyone. It provides printk_in_rcu and
> >> printk_ratelimited_in_rcu to print these strings. In order to avoid a weird
> >> inconsistency between the two, the first patch fixes printk_ratelimited so it
> >> passes on the return value from printk.
> >>
> >> The second patch actually moves the RCU string library. Version 2 passes on the
> >> return values from printk{,_ratelimited} and fixes some style issues.
> >>
> >> Omar Sandoval (2):
> > 
> > For the series:
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Fine by me too, Paul, do you want to merge it in?

I would be happy to.

Are you thinking in terms of 3.18 or 3.19?  These look OK either way, but
thought I should check.

							Thanx, Paul

