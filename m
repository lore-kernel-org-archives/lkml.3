Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaARDFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:05:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41768 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaARDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:05:22 -0500
Date: Fri, 17 Jan 2014 19:05:21 -0800 (PST)
Message-Id: <20140117.190521.915406120394092952.davem@davemloft.net>
To: cl@linux.com
Cc: tj@kernel.org, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH 17/41] net: Replace __this_cpu_inc in route.c with
 raw_cpu_inc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140117151836.140608046@linux.com>
References: <20140117151812.770437629@linux.com>
	<20140117151836.140608046@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>
Date: Fri, 17 Jan 2014 09:18:29 -0600

> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David S. Miller <davem@davemloft.net>
