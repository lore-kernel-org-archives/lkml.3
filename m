Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab3JOSgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:36:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34337 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab3JOSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:36:42 -0400
Message-ID: <1381862199.2045.51.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Date: Tue, 15 Oct 2013 11:36:39 -0700
In-Reply-To: <20131015174745.197380080@linux.com>
References: <20131015174722.615394057@linux.com>
	 <20131015174745.197380080@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 12:47 -0500, Christoph Lameter wrote:
> plain text document attachment (fix_snmp)
> ip4_datagram_connect is called with BH processing enabled. Therefore
> we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> BH handling before incrementing the counter.
> 
> The following trace is triggered without this patch:

> Cc: Eric Dumazet <edumazet@google.com>
> Cc: netdev@vger.kernel.org
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Strange, I thought I already Acked it...

Acked-by: Eric Dumazet <edumazet@google.com>



