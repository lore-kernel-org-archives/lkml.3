Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3GJEgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:36:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35140 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3GJEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:35:58 -0400
Date: Tue, 09 Jul 2013 21:35:55 -0700 (PDT)
Message-Id: <20130709.213555.1037822981842851807.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwgYoGKRLde_4KBnUr1nENpwdahJv8+wHJ502HcGJW1pA@mail.gmail.com>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
	<CA+55aFwgYoGKRLde_4KBnUr1nENpwdahJv8+wHJ502HcGJW1pA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Jul 2013 19:50:41 -0700

> Now, I'm all for making descriptive merge commit messages, including
> improving on the summary line. So by all means write those nice merge
> messages with explanations. I think something like
> 
>     dc3d807d6fd9 Merge "openvswitch: gre tunneling support."
> 
> would have been a *fine* summary line, for example, and quite possibly
> better than the default kind of git merge summary lines (ie "Merge
> branch 'openswitch'"). So I'm not against playing with merge messages
> per se, it's literally this "cannot tell it's a merge any more in the
> summary" that I thing is a problem.

Ok, I'll use that format in the future.  I was actually trying to add
more information, not less. :-) But yeah that header line has to
mention that it's a merge, for sure.
