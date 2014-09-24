Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaIXGYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:24:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIXGYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:24:15 -0400
Date: Wed, 24 Sep 2014 02:24:10 -0400 (EDT)
Message-Id: <20140924.022410.1707532643268164791.davem@davemloft.net>
To: linux@roeck-us.net
Cc: rdunlap@infradead.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-09-22-16-57 uploaded
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140924043423.GA28993@roeck-us.net>
References: <5421E7E1.80203@infradead.org>
	<20140923215356.GA15481@roeck-us.net>
	<20140924043423.GA28993@roeck-us.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Sep 2014 23:24:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 23 Sep 2014 21:34:23 -0700

> On Tue, Sep 23, 2014 at 02:53:56PM -0700, Guenter Roeck wrote:
>> 
>> > Neither of these patches enables CONFIG_NET.  They just add dependencies.
>> > 
>> This means CONFIG_NET is now disabled in at least 31 configurations where
>> it used to be enabled before (per my count), and there may be additional
>> impact due to the additional changes of "select X" to "depends on X".
>> 
>> 3.18 is going to be interesting.
>> 
> Actually, turns out the changes are already in 3.17.
> 
> In case anyone is interested, here is a list of now broken configurations
> (where 'broken' is defined as "CONFIG NET used to be defined, but
> is not defined anymore"). No guarantee for completeness or correctness.

I'll sort this out completely tomorrow.
