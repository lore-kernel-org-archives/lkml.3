Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaA2Epe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:45:34 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:38372 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaA2Epd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
Date: Wed, 29 Jan 2014 10:45:31 +0600
Message-ID: <CADZ9YHjaQtes5XXo1FOSLjqgqbyA_d5LT607+8HRgqXFm-69=g@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 10:09 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Tue, Jan 28, 2014 at 10:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 01/28, Rakib Mullick wrote:
>>
>> You could simply do while_each_thread(p, t) to find a thread which
>> wants_signal(..).
>>
> Yes, while_each_thread() is much nicer than get_nr_thread(), thanks for
> the pointer.
>
Or, should we use for_each_thread()? Just noticed that, you've plan to remove
while_each_thread().

Thanks,
Rakib
