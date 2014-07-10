Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaGJJUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:20:05 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39434 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaGJJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:20:03 -0400
MIME-Version: 1.0
X-Originating-IP: [195.159.206.158]
In-Reply-To: <20140710.014355.387392730830362973.davem@davemloft.net>
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <20140710.014355.387392730830362973.davem@davemloft.net>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 11:19:42 +0200
Message-ID: <CAG-2HqUPRqFgn1PfDoYzuyoYRcfB=RQCVg3PJZvaakiVtK07yw@mail.gmail.com>
Subject: Re: [PATCH v7 00/33] Provide netdev naming-policy via sysfs
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick answer.

On Thu, Jul 10, 2014 at 10:43 AM, David Miller <davem@davemloft.net> wrote:
> It is not reasonable to expect people to review such a large number of
> patches at one time.
>
> Split your series up into logical, and more reasonably sized chunks.
>
> I'd say 14 or 15 at a time is the limit.
>
> I'm not even looking at this series until you submit it more reasonably.
>
> Thank you.

Ok. I suggest you review patches 1-7, as these are the generic ones.
Then once they have been applied I can resubmit the subsequent patches
individually.

Do you want me to resubmit patches 1-7, or do you just want to pick
them from this series as they are?

Cheers,

Tom
