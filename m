Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab3HTKYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:24:18 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42796 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3HTKYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:24:16 -0400
Date: Tue, 20 Aug 2013 02:09:30 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation updates for 3.12
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
In-Reply-To: <20130818012522.GA27015@linux.vnet.ibm.com> (from
	paulmck@linux.vnet.ibm.com on Sat Aug 17 20:25:22 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1376982570.2737.62@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 08:25:22 PM, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Update rcu_barrier() documentation to note that it no longer is
> 	guaranteed to wait for a full grace period.  This guarantee was
> 	a victim of energy efficiency.
> 
> 2.	Update RTFP documentation.
> 
> 3.	Fix a control-dependency example in the memory-barriers
> 	documentation.

Acked-by: Rob Landley <rob@landley.net>

(I'm just happy you don't have gratuitous quizzes mixed through it...)

Rob