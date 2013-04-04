Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764376Ab3DDSP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:15:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764360Ab3DDSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:15:25 -0400
Date: Thu, 04 Apr 2013 14:15:21 -0400 (EDT)
Message-Id: <20130404.141521.131050563803429013.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: laijs@cn.fujitsu.com, brgerst@gmail.com, davej@redhat.com, jason@x264.com,
        andi@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        dingtianhong@huawei.com, ksrot@redhat.com, edumazet@google.com
Subject: Re: af_unix udev startup regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFz8XqvM6_BP2NEyLR4c-yXST6S4uszOwx5xfP6Z+nhAZw@mail.gmail.com>
References: <CA+55aFz8XqvM6_BP2NEyLR4c-yXST6S4uszOwx5xfP6Z+nhAZw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 04 Apr 2013 11:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Apr 2013 11:03:28 -0700

> [ Fixed odd legacy subject line that has nothing to do with the actual bug ]
> 
> Hmm. Can you double-check and verify that reverting that commit makes
> things work again for you?
> 
> Also, what's your distribution and setup? I'd like this to get
> verified, just to see that it's not some timing-dependent thing or a
> bisection mistake, but if so, then the LSB test-cases obviously have
> to be fixed, and the commit that causes the problem needs to be
> reverted. Test-cases count for nothing compared to actual users.

We're in the process of discussing resolving this AF_UNIX credentials
passing issue in another thread.

I hope to have something to push to you very soon.
