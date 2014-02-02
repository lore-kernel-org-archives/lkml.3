Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBBUWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 15:22:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49446 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaBBUWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:22:37 -0500
Message-ID: <52EEA865.3090806@zytor.com>
Date: Sun, 02 Feb 2014 12:19:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mateusz Guzik <mguzik@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH RFC] compat: Get rid of (get|put)_compat_time(val|spec)
References: <1391310232-8520-1-git-send-email-hpa@linux.intel.com> <CA+55aFyuOS==c5iihr3__OECkwdwd7WuzEieJ1UvHsgoXW+7bQ@mail.gmail.com>
In-Reply-To: <CA+55aFyuOS==c5iihr3__OECkwdwd7WuzEieJ1UvHsgoXW+7bQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 11:08 AM, Linus Torvalds wrote:
> On Sat, Feb 1, 2014 at 7:03 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> Clean it up by favoring the full-service version; the limited version
>> is replaced with double-underscore versions static to kernel/compat.c.
> 
> Ack. Make it so. I assume you've tested this on x32 (and hopefully
> x86-32 on a 64-bit kernel), and that I will get this through the x86
> git trees?
> 

Testing?  ;)

Nothing has been tested so far, but I definitely will before pushing it
to you, and yes, will send it through the tip tree.

	-hpa


