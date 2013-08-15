Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3HOOWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:22:44 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53024 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab3HOOWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <520CDF92.8090804@roeck-us.net>
References: <520C9A39.3030808@roeck-us.net>
	<CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
	<520CDF92.8090804@roeck-us.net>
Date: Thu, 15 Aug 2013 18:22:42 +0400
Message-ID: <CAMo8BfLzmFROWkmH5Wzjf5HNhkuxvc83ieCbEwdfoeR2msZwbQ@mail.gmail.com>
Subject: Re: Linux kernel cross-compilers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: tony@bakeyournoodle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 6:02 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/15/2013 02:46 AM, Max Filippov wrote:
>>
>> Hi Guenter,
>>
>> On Thu, Aug 15, 2013 at 1:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> Also, the xtensa compiler fails for me with an odd error message on one
>>> of
>>> my servers.
>>
>>
>> What is the message?
>>
> It complains about being unable to change the byte order in an object file.
>
> Actually, the message is from the linker, but I have no idea what is causing
> it.

I've seen such message when I attempted to link a kernel, parts of which
were by mistake compiled for different xtensa core variants. Clean rebuild
fixed that.

> It works on two servers but fails on the third. At least in theory the
> installation
> on all servers should be the same.

-- 
Thanks.
-- Max
