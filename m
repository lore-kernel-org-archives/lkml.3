Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3IDUYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:24:17 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57247 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3IDUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <CANcMJZAv_-nGkjt8r8cp+BhnSfhL2roKZpodN+vLKfmpTVLhrQ@mail.gmail.com>
References: <5226FAE1.5070201@fb.com> <CANcMJZAv_-nGkjt8r8cp+BhnSfhL2roKZpodN+vLKfmpTVLhrQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 13:23:54 -0700
Message-ID: <CALCETrVdAGbp-ogvideZ6GiDVu8W3v+6Z=hJSrr+62U50HG8wg@mail.gmail.com>
Subject: Re: clock_gettime_ns
To: John Stultz <john.stultz@linaro.org>
Cc: Arun Sharma <asharma@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 12:17 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Wed, Sep 4, 2013 at 2:18 AM, Arun Sharma <asharma@fb.com> wrote:
>> A couple of years ago Andy posted this patch series:
>>
>> http://thread.gmane.org/gmane.linux.kernel/1233209/
>>
>> These patches have been in use at facebook for a couple of years and along
>> with a vDSO implementation of thread_cpu_time(), they have proven useful for
>> our profilers.
>>
>> I didn't see any arguments against this patch series. Did I miss some
>> discussion on the topic?
>
> (I've got a new email address, just fyi)
>
> So, looking at the thread, I think Richard brought up the issue that
> the net performance gain with the new interface wasn't significant
> after the optimizations were applied to both interfaces.
>
> If we're going to add a new interface that uses something other then a
> timespec, we likely need to put some serious thought into that new
> type, and see how it could be used across a number of syscalls. Some
> of the discussion around dealing with the 2038 issue touched on this.
>
> But getting those optimizations to the existing interface merged would
> be nice, though.  Anyone want to resend the patch?

It's already in.  See 5f293474c4c6c4dc2baaf2dfd486748b5986de76, etc.

--Andy
