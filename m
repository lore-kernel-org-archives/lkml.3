Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaCCCB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:01:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaCCCBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:01:53 -0500
Message-ID: <5313E28B.5030902@oracle.com>
Date: Sun, 02 Mar 2014 21:01:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: gpf in simple_setattr
References: <52B23CEA.7090405@oracle.com>	<52CD762B.7020600@oracle.com>	<53123D81.6080003@oracle.com> <CA+55aFxYKbzjSOz6Ui-QcxwN6NuuPM2vnAUw_SxnjzNM9oGcjg@mail.gmail.com>
In-Reply-To: <CA+55aFxYKbzjSOz6Ui-QcxwN6NuuPM2vnAUw_SxnjzNM9oGcjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 10:35 PM, Linus Torvalds wrote:
> On Sat, Mar 1, 2014 at 2:05 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> ping again?
>>
>> I've been working on it, but don't see an obvious issue.
>>
>> It does look like an access to invalid memory easily doable from userspace,
>> so it should probably get fixed soon...
>
> It doesn't happen in mainline? Any possibility that you could try to bisect it?

It might be in mainline, it just happens once in a couple of days and since I'm not usually fuzzing 
mainline I can't say for sure.

I've tried bisecting but since I don't have a reliable way to reproduce it the bisection goes wrong 
pretty fast.

I've tried adding some debug code in, which clearly suggests that the object is gone, but I can't 
pinpoint to where it disappears.


Thanks,
Sasha

