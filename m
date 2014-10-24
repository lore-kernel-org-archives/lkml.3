Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaJXQpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:45:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51135 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbaJXQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:45:19 -0400
Date: Fri, 24 Oct 2014 12:45:15 -0400 (EDT)
Message-Id: <20141024.124515.201736092509249490.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410241048290.15464@adalberg.ut.ee>
References: <20141023.130258.548864295965807596.davem@davemloft.net>
	<20141023.172258.1371479087269518956.davem@davemloft.net>
	<alpine.LRH.2.11.1410241048290.15464@adalberg.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Oct 2014 09:45:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Fri, 24 Oct 2014 10:49:12 +0300 (EEST)

>> > I can reproduce and I know what the problem is, fixed patch coming up
>> > shortly.
>> 
>> Ok, please test this patch below.
> 
> Thank you, it works fine on my V210, V440 and newly added V245.

Thanks so much for testing.

I'll clean this up based upon Sam's feedback, add your Tested-by:,
and push it around.

Thanks again!
