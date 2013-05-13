Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab3EMI7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:59:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:43433 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3EMI7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:59:50 -0400
Message-ID: <1368435563.19924.28.camel@pasglop>
Subject: Re: [RFC PATCH v3 0/5] powerpc: Support context tracking for Power
 pSeries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, paulus@samba.org,
        michael@ellerman.id.au, Anton Blanchard <anton@au1.ibm.com>
Date: Mon, 13 May 2013 18:59:23 +1000
In-Reply-To: <1368432193.2618.30.camel@ThinkPad-T5421>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368424306.19924.20.camel@pasglop>
	 <1368432193.2618.30.camel@ThinkPad-T5421>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 16:03 +0800, Li Zhong wrote:
> 
> To my understanding, it is used to enable RCU user extended quiescent
> state, so RCU on that cpu doesn't need scheduler ticks. And together
> with some other code(already in 3.10), we are able to remove the ticks
> in some cases (e.g. only 1 task running on the cpu, with some other
> limitations).

Ok, sounds interesting. Once you fix the little cosmetic issue, I don't
see any reason not to merge them as it's basically wiring up an existing
feature (in that regard the patches are pretty straightforward) and I
assume the overhead is only there when you enable it.

Cheers,
Ben.


