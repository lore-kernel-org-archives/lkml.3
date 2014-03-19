Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaCSJ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:58:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaCSJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:58:17 -0400
Date: Wed, 19 Mar 2014 10:58:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 00/31] Clean up smp_mb__ barriers
Message-ID: <20140319095807.GF27632@laptop.programming.kicks-ass.net>
References: <20140319064729.660482086@infradead.org>
 <13632.1395222905@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13632.1395222905@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:55:05AM +0000, David Howells wrote:
> 
> Shouldn't the mass-conversion patch (patch 31) go first?

You mean; make the kernel use primitives that aren't there yet?
