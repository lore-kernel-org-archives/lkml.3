Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab3BTRu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:50:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48020 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3BTRu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:50:56 -0500
Date: Wed, 20 Feb 2013 12:50:48 -0500 (EST)
Message-Id: <20130220.125048.1965504750915247194.davem@davemloft.net>
To: mroos@linux.ee
Cc: rientjes@google.com, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1302201437190.20165@math.ut.ee>
References: <20130219.144608.1425049879680985441.davem@davemloft.net>
	<20130220.014137.1184382041985855584.davem@davemloft.net>
	<alpine.SOC.1.00.1302201437190.20165@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 09:50:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 20 Feb 2013 15:35:52 +0200 (EET)

>> Ok I've written an alternative version of the fix that I've been busy
>> testing all evening.
>> 
>> I think it's much better and it's about to be posted as a series of 3
>> patches.
> 
> Works much better. aptitude worked fine, as did 5 times
> cp -a linux test; rm -r linux
> 
> However, "git gc" in a copy of the repository hung the machine hard, 
> nothing in the logs.
> 
> 3.8.0 with THP disabled can run both cp;rm and git gc several 
> times without a problem.

Thanks for testing, I'll try to reproduce.
