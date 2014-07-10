Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaGJTMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:12:09 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:57546 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaGJTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:12:07 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <CAG-2HqUPRqFgn1PfDoYzuyoYRcfB=RQCVg3PJZvaakiVtK07yw@mail.gmail.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <20140710.014355.387392730830362973.davem@davemloft.net> <CAG-2HqUPRqFgn1PfDoYzuyoYRcfB=RQCVg3PJZvaakiVtK07yw@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 21:11:46 +0200
Message-ID: <CAG-2HqVLE=P6KTPnZY4d6jzkQ5_1C-ETJRu6AH0KcY9FAFBASA@mail.gmail.com>
Subject: Re: [PATCH v7 00/33] Provide netdev naming-policy via sysfs
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:19 AM, Tom Gundersen <teg@jklm.no> wrote:
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

I'll redo the first few patches based on the comments received so far,
and resend them in a shorter series, so no need to review the current
one.

Thanks.

Tom
