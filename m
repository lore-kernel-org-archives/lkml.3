Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3JKSci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:32:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47216 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3JKScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:32:36 -0400
Message-ID: <1381516354.4971.111.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 11 Oct 2013 11:32:34 -0700
In-Reply-To: <00000141a8a7eb8a-370733b2-d230-4567-96e1-74c028998bff-000000@email.amazonses.com>
References: <20131011175518.634285474@linux.com>
	 <00000141a8a7eb8a-370733b2-d230-4567-96e1-74c028998bff-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 17:54 +0000, Christoph Lameter wrote:
> ip4_datagram_connect is called with BH processing enabled. Therefore
> we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> BH handling before incrementing the counter.
> 
> The following trace is triggered without this patch:
...
> Cc: Eric Dumazet <edumazet@google.com>
> CC: netdev@vger.kernel.org
> Signed-off-by: Christoph Lameter <cl@linux.com>


Patch is fine but was not CC to netdev and David Miller.

Acked-by: Eric Dumazet <edumazet@google.com>


