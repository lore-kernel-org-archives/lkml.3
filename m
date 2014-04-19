Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaDSRJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:09:17 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51162 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaDSRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140419112821.6ee5b104@gandalf.local.home>
References: <1397915903-21326-1-git-send-email-linyongting@gmail.com>
	<20140419112821.6ee5b104@gandalf.local.home>
Date: Sun, 20 Apr 2014 01:09:15 +0800
Message-ID: <CANWV4VmqxZYMP26fV+Dt3h6LubyYppdgpxkRxetmtJOZbpzYkA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Correct braces usage in if-else statement
From: ivan lin <linyongting@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        mingo@redhat.com, linux-kernel@vger.kernel.org, linyongting@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-19 23:28 GMT+08:00 Steven Rostedt <rostedt@goodmis.org>:
> On Sat, 19 Apr 2014 21:58:23 +0800
> Lin Yongting <linyongting@gmail.com> wrote:
>
>> There are some incorrect braces usages in kernerl/trace/trace.c, including:
>> 1. Missing braces in 'if' or 'else' branch.
>> 2. Unnecessary braces in 'if' statement.
>>
>> Fix them according to kernel CodeStyle.
>
> I understand that this is part of the CodeStyle, but I'm not accepting
> this patch. It causes more pain than it is worth, as it makes it more
> difficult to see git history because of "clean up" changes that get in
> the way. I also honestly don't think this is much of a clean up.
>
> Sorry,
>
> -- Steve
>

Yes, you are right.  This clean up is pain than it is worth.

Thnaks!

-- Yongting.
