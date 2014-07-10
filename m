Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaGJTTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:19:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42618 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaGJTTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:19:40 -0400
Date: Thu, 10 Jul 2014 12:19:37 -0700 (PDT)
Message-Id: <20140710.121937.888036537035743904.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dh.herrmann@gmail.com, kay@vrfy.org
Subject: Re: [PATCH v7 00/33] Provide netdev naming-policy via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG-2HqUPRqFgn1PfDoYzuyoYRcfB=RQCVg3PJZvaakiVtK07yw@mail.gmail.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<20140710.014355.387392730830362973.davem@davemloft.net>
	<CAG-2HqUPRqFgn1PfDoYzuyoYRcfB=RQCVg3PJZvaakiVtK07yw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 12:19:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 11:19:42 +0200

> Thanks for the quick answer.
> 
> On Thu, Jul 10, 2014 at 10:43 AM, David Miller <davem@davemloft.net> wrote:
>> It is not reasonable to expect people to review such a large number of
>> patches at one time.
>>
>> Split your series up into logical, and more reasonably sized chunks.
>>
>> I'd say 14 or 15 at a time is the limit.
>>
>> I'm not even looking at this series until you submit it more reasonably.
>>
>> Thank you.
> 
> Ok. I suggest you review patches 1-7, as these are the generic ones.
> Then once they have been applied I can resubmit the subsequent patches
> individually.
> 
> Do you want me to resubmit patches 1-7, or do you just want to pick
> them from this series as they are?

I said submit it more reasonably, what do you think that means?
