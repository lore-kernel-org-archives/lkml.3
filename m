Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaJSR1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:27:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55013 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaJSR1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:27:40 -0400
Date: Sun, 19 Oct 2014 13:27:37 -0400 (EDT)
Message-Id: <20141019.132737.1392053813844289431.davem@davemloft.net>
To: sam@ravnborg.org
Cc: mroos@linux.ee, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141019153219.GA10644@ravnborg.org>
References: <20141018.135907.356113264227709132.davem@davemloft.net>
	<20141018.142335.1935310766779155342.davem@davemloft.net>
	<20141019153219.GA10644@ravnborg.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 10:27:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 19 Oct 2014 17:32:20 +0200

> This part:
> 
>> +		__attribute__ ((aligned(64)));
> 
> Could be written as __aligned(64)

I'll try to remember to sweep this up in sparc-next, thanks Sam.

We probably use this long-hand form in a lot of other places in
the sparc code too, so I'll try to do a full sweep.

Thanks again.

