Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaG0Io0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 04:44:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44585 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaG0IoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 04:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyD-R-ex8OadHV9pkz7gGOf09_8qfAwq-xB1URZqFH33w@mail.gmail.com>
References: <CAPb+xgO9_7FQ3NM1NCL8zW5hMzUcWASxu-mk3e64Y+V_DnkMzg@mail.gmail.com>
	<CAFLxGvyD-R-ex8OadHV9pkz7gGOf09_8qfAwq-xB1URZqFH33w@mail.gmail.com>
Date: Sun, 27 Jul 2014 14:14:20 +0530
Message-ID: <CAPb+xgP+1MvSJsQkdsTT-W3VXCHLYV2FyQ_bNO=Seb6RKbVKPA@mail.gmail.com>
Subject: Re: "copy_to_user" function not working in stable build "2.6.36.4"
From: zubraz singha <zubrajsingha@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do understand that this is a very old build and its not being
supported. As I wrote in my earlier mail,  the function works fine
with higher kernel versions. I will try to find out a work around for
this. Appreciate your feedback.

Zubraj

On 7/27/14, Richard Weinberger <richard.weinberger@gmail.com> wrote:
> On Sun, Jul 27, 2014 at 10:22 AM, zubraz singha <zubrajsingha@gmail.com>
> wrote:
>> Hey Guys,
>> While writing a read proc entry for Linux kernel (version 2.6.36.4), I
>> found that the kernel function "copy_to_user" is not working properly.
>> The kernel function used internally by "copy_to_user" i.e.
>> "__copy_to_user" works fine and also this same function "copy_to_user"
>> works quite well on the higher kernel versions,  I tried it on Linux
>> kernel version 3.14.  The kernel source code for  "2.6.36.4" doesn't
>> have a definition for a function i.e "_copy_to_user",  which is being
>> called internally by "copy_to_user". However the function
>> "_copy_to_user" has a definition  in higher version kernels like 3.14
>> etc. I cannot update my kernel,  Is there any way I can fix this issue
>> by manually patching the kernel. There are two possible ways in which
>> I think it can be solved.
>>
>> - Write a definition for the _copy_to_user in "2.6.36.4", which will
>> have the same "access_ok" check and corresponding  "__copy_to_user"
>> function call.
>> - Modifying the function "copy_to_user" and adding the "access_ok"
>> check and the "__copy_to_user" function.
>
> 2.6.36.x is not a supported release. The issue is maybe fixed in other
> versions but as
> your release is not a stable kernel you are on your own. Sorry.
>
> --
> Thanks,
> //richard
>


-- 
-- Regards
Zubraj Singha
