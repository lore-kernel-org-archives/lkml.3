Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaCLGY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:24:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47524 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaCLGYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:24:55 -0400
Date: Wed, 12 Mar 2014 07:24:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, arnd@arndb.de, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312062436.GI30956@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
 <20140311104503.GA10916@gmail.com>
 <531FD1DA.5010006@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531FD1DA.5010006@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:17:46PM -0400, Waiman Long wrote:
> Except that I do a single atomic short integer write to switch the bits
> instead of 2 byte write.

D'0h why didn't I think of that. A single short write is much better
than the 2 byte writes.

In any case; can you try and keep the structure in this patch-set if you
post another version? It takes a lot of effort to unravel your
all-in-one patch.
