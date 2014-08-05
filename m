Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaHEF5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:57:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49462 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaHEF5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:57:30 -0400
Date: Mon, 04 Aug 2014 22:57:29 -0700 (PDT)
Message-Id: <20140804.225729.663353171881658413.davem@davemloft.net>
To: marcel@holtmann.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-08-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <ED6BF15D-CA1F-4E35-8301-E9A9EEDE3AD6@holtmann.org>
References: <C2EB98EF-6873-4F44-B914-A9F89146914A@holtmann.org>
	<20140804145342.GB16658@tuxdriver.com>
	<ED6BF15D-CA1F-4E35-8301-E9A9EEDE3AD6@holtmann.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 22:57:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 4 Aug 2014 22:39:47 -0700

> Hi Dave,
> 
>>>>> Please pull this last(?) batch of wireless change intended for the
>>>>> 3.17 stream...
>>>> 
>>>> When I pull this I get tons of conflicts for:
>>>> 
>>>> CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
>>>> 
>>>> I don't feel comfortable fixing these up, where are they coming
>>>> from?
>>> 
>>> I was short on time yesterday, but now I checked up on this in detail. The merge conflicts are actually simple to resolve. You can just rely on John's tree to have the more recent net/6lowpan/ tree. I should have insisted on merging net/6lowpan/ through bluetooth-next and wireless-next way earlier to avoid conflicts.
>>> 
>>> In the future we will avoid this by ensuring that all goes via bluetooth-next first. Sorry for this confusion. John mentioned these merge conflicts in his footnote.
>>> 
>>> John, do you just want to resolve the merge conflicts and send Dave a new pull request?
>> 
>> I'm happy to do that, if Dave wants.  But as you say, once the initial
>> shock of all those conflicts passes the resolution really is fairly
>> simple. :-)
> 
> do you want John to just do the merge conflict resolution? They are all trivial.

I am going to try and do it myself, I just haven't gotten around to it.

Thanks for asking.
