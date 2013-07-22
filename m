Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3GVKoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:44:08 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48680 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3GVKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <51ED0BBF.7060502@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com> <51ED0BBF.7060502@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 16:13:25 +0530
Message-ID: <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Lennart Poettering <lennart@poettering.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Corrected Lennart's email ID]

Richard Weinberger wrote:
> CC'ing Lennart.
>
> Am 22.07.2013 11:45, schrieb Ramkumar Ramachandra:
>> Ramkumar Ramachandra wrote:
>>> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
>>
>> ... and the patches were rejected.  Lennart says that UML providing
>> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
>> something).  Can we do something about the situation?  Can we remove
>> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
>>
>> Thanks.
>>
>> Lennart Poettering wrote:
>>> UML shouldn't be penalized for not implementing some terminal emulation,
>>> but it should be penalized for doing so under the label of "VT support",
>>> which it simply is not providing.
>>>
>>> They can call their ttys any way they want. If the call them
>>> /dev/tty[1..64] however, then they need to implement the VC
>>> interfaces. All of them.
>
> Lennart, can you please explain us why /dev/tty[1..64] is forced to
> have virtual console support?
>
> Thanks,
> //richard
