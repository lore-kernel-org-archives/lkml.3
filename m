Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3GVKjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:39:03 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757174Ab3GVKjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:39:01 -0400
Message-ID: <51ED0BBF.7060502@nod.at>
Date: Mon, 22 Jul 2013 12:38:55 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com> <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com> <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
In-Reply-To: <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Lennart.

Am 22.07.2013 11:45, schrieb Ramkumar Ramachandra:
> Ramkumar Ramachandra wrote:
>> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
> 
> ... and the patches were rejected.  Lennart says that UML providing
> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
> something).  Can we do something about the situation?  Can we remove
> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
> 
> Thanks.
> 
> Lennart Poettering wrote:
>> UML shouldn't be penalized for not implementing some terminal emulation,
>> but it should be penalized for doing so under the label of "VT support",
>> which it simply is not providing.
>>
>> They can call their ttys any way they want. If the call them
>> /dev/tty[1..64] however, then they need to implement the VC
>> interfaces. All of them.

Lennart, can you please explain us why /dev/tty[1..64] is forced to
have virtual console support?

Thanks,
//richard
