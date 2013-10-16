Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3JPGJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:09:38 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39796 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3JPGJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:09:36 -0400
Date: Wed, 16 Oct 2013 08:09:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
Message-ID: <20131016060932.GA21041@gmail.com>
References: <20131015174722.615394057@linux.com>
 <20131015174745.197380080@linux.com>
 <1381862199.2045.51.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381862199.2045.51.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Tue, 2013-10-15 at 12:47 -0500, Christoph Lameter wrote:
> > plain text document attachment (fix_snmp)
> > ip4_datagram_connect is called with BH processing enabled. Therefore
> > we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> > BH handling before incrementing the counter.
> > 
> > The following trace is triggered without this patch:
> 
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: netdev@vger.kernel.org
> > Cc: David Miller <davem@davemloft.net>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Strange, I thought I already Acked it...
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Christoph, _please_ pick up people's Acked-by's in the future ... This is 
basic courtesy towards reviewers.

Thanks,

	Ingo
