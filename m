Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3ENH7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:59:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:56203 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3ENH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:59:32 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Tux3 Report: Faster than tmpfs, what?
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard> <87fvxvz8qw.fsf@devron.myhome.or.jp>
	<20130514063438.GF29466@dastard>
Date: Tue, 14 May 2013 16:59:29 +0900
In-Reply-To: <20130514063438.GF29466@dastard> (Dave Chinner's message of "Tue,
	14 May 2013 16:34:38 +1000")
Message-ID: <87mwrydmam.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> Right. Because tux3 is not implementing fsync() yet. So, I did
>> 
>> 	grep -v Flush /usr/share/dbench/client.txt > client2.txt
>> 
>> Why is it important for comparing?
>
> Because nobody could reproduce your results without working that
> out. You didn't disclose that you'd made these changes, and that
> makes it extremely misleading as to what the results mean. Given the
> headline-grab nature of it, it's deceptive at best.
>
> I don't care how fast tux3 is - I care about being able to reproduce
> other people's results. Hence if you are going to report benchmark
> results comparing filesystems then you need to tell everyone exactly
> what you've tweaked and why, from the hardware all the way up to the
> benchmark config.

Thanks for adivce.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
