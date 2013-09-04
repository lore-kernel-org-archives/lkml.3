Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131Ab3IDUuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:50:35 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37799 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3IDUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:50:34 -0400
Message-ID: <52279D17.2010607@linaro.org>
Date: Wed, 04 Sep 2013 13:50:31 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Arun Sharma <asharma@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CANcMJZAv_-nGkjt8r8cp+BhnSfhL2roKZpodN+vLKfmpTVLhrQ@mail.gmail.com> <CALCETrVdAGbp-ogvideZ6GiDVu8W3v+6Z=hJSrr+62U50HG8wg@mail.gmail.com>
In-Reply-To: <CALCETrVdAGbp-ogvideZ6GiDVu8W3v+6Z=hJSrr+62U50HG8wg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:23 PM, Andy Lutomirski wrote:
> On Wed, Sep 4, 2013 at 12:17 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On Wed, Sep 4, 2013 at 2:18 AM, Arun Sharma <asharma@fb.com> wrote:
>>> A couple of years ago Andy posted this patch series:
>>>
>>> http://thread.gmane.org/gmane.linux.kernel/1233209/
>>>
>>> These patches have been in use at facebook for a couple of years and along
>>> with a vDSO implementation of thread_cpu_time(), they have proven useful for
>>> our profilers.
>>>
>>> I didn't see any arguments against this patch series. Did I miss some
>>> discussion on the topic?
>> (I've got a new email address, just fyi)
>>
>> So, looking at the thread, I think Richard brought up the issue that
>> the net performance gain with the new interface wasn't significant
>> after the optimizations were applied to both interfaces.
>>
>> If we're going to add a new interface that uses something other then a
>> timespec, we likely need to put some serious thought into that new
>> type, and see how it could be used across a number of syscalls. Some
>> of the discussion around dealing with the 2038 issue touched on this.
>>
>> But getting those optimizations to the existing interface merged would
>> be nice, though.  Anyone want to resend the patch?
> It's already in.  See 5f293474c4c6c4dc2baaf2dfd486748b5986de76, etc.
Great!
-john

