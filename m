Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaGPMrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:47:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44898 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaGPMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:47:33 -0400
Date: Wed, 16 Jul 2014 05:47:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: josh@joshtriplett.org, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
Message-ID: <20140716124729.GR8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
 <1405463509-2468-2-git-send-email-bobby.prani@gmail.com>
 <20140715225313.GB24290@cloud>
 <53C5B1F7.3000409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5B1F7.3000409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071612-9332-0000-0000-000001665F41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:57:59PM -0400, Pranith Kumar wrote:
> 
> On 07/15/2014 06:53 PM, josh@joshtriplett.org wrote:
> > On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
> >> This commit removes a stale comment in rcu/tree.c.
> >> FYI, an updated comment exists a few lines below this.
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> > In general, when removing a stale comment, I'd suggest explaining why
> > the comment is stale.  Was code removed without removing the
> > corresponding comment, or was code changed such that the comment no
> > longer applies, or...?
> 
> I guess it was left out when code was moved around previously. And I did mention that an updated comment is there a few lines below.
> 
> For reference this is the new comment which is below the old comment, they mean the same :)
> 
>     /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */

Indeed that is the case.

Please update the commit log with this explanation and resend.

								Thanx, Paul

