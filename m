Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3ALTj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 14:39:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43877 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3ALTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 14:39:56 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301121232510.32458-100000@netrider.rowland.org>
References: <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
 <Pine.LNX.4.44L0.1301121232510.32458-100000@netrider.rowland.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sat, 12 Jan 2013 20:39:36 +0100
Message-ID: <CALxABCbLmsg-gt-5MzQJv-Sy1qqnWh-Vr6HUutq=DzNO8M+s1A@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 6:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 12 Jan 2013, Alex Riesen wrote:
>> One more detail: I usually use the "noop" elevator. That time it was
>> the "deadline". And I just reproduced it easily with "deadline".
>
> I doubt the elevator has anything to do with this.

But it looks like it does: just using the deadline elevator is a sure way
to reproduce the bug. The system always recovers (sometimes after a while)
with "noop".
