Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaIHF2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 01:28:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60462 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaIHF2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 01:28:45 -0400
Date: Sun, 07 Sep 2014 22:28:41 -0700 (PDT)
Message-Id: <20140907.222841.1933004265241590374.davem@davemloft.net>
To: mingo@kernel.org
Cc: ast@plumgrid.com, pablo@netfilter.org, torvalds@linuxfoundation.org,
        luto@amacapital.net, rostedt@goodmis.org, dborkman@redhat.com,
        hannes@stressinduktion.org, chema@google.com, edumazet@google.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, akpm@linuxfoundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and
 expose eBPF to user space
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140908052329.GA30461@gmail.com>
References: <20140907180737.GA5057@salvia>
	<CAMEtUuxJLDu8AAsZQdtG781vwC8y60Ygdt4ji5tbeyTE8YbWbQ@mail.gmail.com>
	<20140908052329.GA30461@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Sep 2014 22:28:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Mon, 8 Sep 2014 07:23:29 +0200

> 
> * Alexei Starovoitov <ast@plumgrid.com> wrote:
> 
>> > I don't think the speed up of the llvm submission is a good 
>> > argument, this sounds to me similar to the "please apply this 
>> > patch that reserves this new netlink family in 
>> > include/linux/netlink.h, I promise this new subsystem will be 
>> > submitted soon though. Meanwhile this will speed up 
>> > submission of my userspace software to distributions for 
>> > packaging" argument.
>> 
>> You're not correct here. I'm not saying 'I promise it will be 
>> submitted'. There _were_ already submitted. [...]
> 
> And this split-up smaller submissions was requested by David 
> Miller, the networking maintainer, so if Pablo wants another 
> submission format, he needs to take it up with David - we can't 
> do both at once obviously.

I think that just because I asked the submission size to be smaller,
it does not mean that you can submit things before you provide the
initial user as well.

And how to work that out and keep the submission size reasonable is
the submitter's problem, not mine.
