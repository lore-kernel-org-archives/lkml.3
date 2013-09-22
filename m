Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3IVXCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:02:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52009 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3IVXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:02:38 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130921200132.GF2312@kernel.dk>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>
	<x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
	<26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
	<x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
	<5228913A.50807@kernel.dk>
	<CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
	<5238B9A7.6040002@kernel.dk>
	<20130920153128.63244ec2658b7ad3aee0e2e4@linux-foundation.org>
	<20130921200132.GF2312@kernel.dk>
Date: Sun, 22 Sep 2013 16:02:37 -0700
Message-ID: <CAOesGMg2t551P7a1wa=FkTjgDaeXedCej87oi+yF2c3Q-hoP5g@mail.gmail.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
From: Olof Johansson <olof@lixom.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
        OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 1:01 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Sep 20 2013, Andrew Morton wrote:
>> On Tue, 17 Sep 2013 14:20:55 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>>
>> > > So, it looks like this driver needs a bunch of work before it's ready
>> > > to go in. Or, maybe it's better to submit it with a TODO list for the
>> > > staging tree instead?
>> >
>> > Not disagreeing with you, it definitely needs a bit of cleaning. And so
>> > far stec has not been very responsive in fixing those issues.
>>
>> Geeze.  Here's what I came up with, mainly to make i386 compile:
>
> Thanks Andrew. It's not the fixes themselves that are tricky, I would
> just have liked a little more proof that the submission wasn't just a
> dump'n run.

Well, that's what much of the staging process is about, since it needs
to come with a todo list (and that list needs to be taken care of
before the driver graduates). Honestly, this looks like a prime
candidate for that. But it's your tree and your call.

Thanks for applying the patch from Andrew, that resolves most of it
for me right now.


-Olof
