Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3GKUBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:01:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59230 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3GKUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:01:35 -0400
Date: Thu, 11 Jul 2013 13:01:32 -0700 (PDT)
Message-Id: <20130711.130132.1487792546552701732.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fchecconi@gmail.com, rizzo@iet.unipi.it,
        David.Laight@ACULAB.COM
Subject: Re: [PATCH 0/2] pkt_sched: sch_qfq: efficiency and codestyle
 improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373463969-11285-1-git-send-email-paolo.valente@unimore.it>
References: <20130305.235006.1904081547083683406.davem@davemloft.net>
	<1373463969-11285-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Wed, 10 Jul 2013 15:46:07 +0200

> Hi,
> this patchset tries to address the two issues raised by Dave in
> http://marc.info/?l=linux-kernel&m=136254542019113&w=2
> 
> The first of these issues has been also raised by
> David Laight:
> http://marc.info/?l=linux-kernel&m=136256446624557&w=2
> 
>> Although two topics for possibly resolving later:
>> 
>> 1) That 1ULL bit mask fix is quite expensive on 32-bit, it would
>>     probably be cheaper to test for that case using a helper function
>>     that nops out on 64-bit.  Although this is not so important.
>> 
> I have tried to find a simple solution, based on the properties of the mask.
> It is in the first patch.
> 
>> 2) That static inline forward declaration is ugly, better to remove
>>     the inline tag (let the compiler handle it) or move the function
>>     above all the call sites.
>> 
> Done by the second patch.

Looks good, thanks for doing this, both applied.
