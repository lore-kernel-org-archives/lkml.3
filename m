Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbaFTPwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:52:19 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41482 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801AbaFTPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:52:15 -0400
Date: Fri, 20 Jun 2014 11:52:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140620155210.GA21818@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
 <20140617194017.GO4669@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
 <20140619204634.GB9814@mtj.dyndns.org>
 <alpine.DEB.2.11.1406191608290.5484@gentwo.org>
 <20140619211543.GD9814@mtj.dyndns.org>
 <alpine.DEB.2.11.1406201022300.10810@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406201022300.10810@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:23:57AM -0500, Christoph Lameter wrote:
> > You're repeatedly getting wayside in the discussion.  What are you
> > suggesting?  Sending IPIs on each percpu allocation?
> 
> No this is about sending an IPI if you want to modify the percpu data of
> another process. There was a mentionig of code that modifies the per cpu
> data of another processor?

Yes, the initialization of percpu areas on allocation.  That was the
*sole* subject of this thread.

-- 
tejun
