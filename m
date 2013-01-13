Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3AMMJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:09:33 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:48387 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3AMMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301121748360.4723-100000@netrider.rowland.org>
References: <CALxABCb1Z5fg4zPfTa5ka7WDjUNZSR4-n4P+fazdQLMD4F5njw@mail.gmail.com>
 <Pine.LNX.4.44L0.1301121748360.4723-100000@netrider.rowland.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sun, 13 Jan 2013 13:09:11 +0100
Message-ID: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 11:52 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 12 Jan 2013, Alex Riesen wrote:
>> Now, who would be interested to handle this kind of misconfiguration ...
>
> So the whole thing was a false alarm?

Yes, almost. What about khubd hanging when machine is shutdown?

> Maybe you should report to the block-layer maintainers that it's
> possible to mess up the system by building an elevator as a module.
> That sounds like the sort of thing they'd be interested to hear.

Hi Jens,

may I point you at this problem report:

http://thread.gmane.org/gmane.linux.kernel/1420814

It is surely a misconfiguration on my part (the used io scheduler
configured as a module), but the behavior is somewhat problematic
anyway: at least in this case USB storage is essentially locked up.

Regards,
Alex
