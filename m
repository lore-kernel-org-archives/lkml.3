Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab3BTBNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:13:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:39980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3BTBNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:13:52 -0500
Message-ID: <51242379.9030909@infradead.org>
Date: Tue, 19 Feb 2013 17:14:33 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: What is tip-bot?
References: <512348A1.4000305@ahsoftware.de> <CAFLxGvzuL+w-yfApiLGwWWbB8Om7JUypppoovmSGS2k51Yjgmw@mail.gmail.com> <512355C2.3050009@ahsoftware.de> <512402A7.9020500@infradead.org> <51241ED2.5080105@ahsoftware.de>
In-Reply-To: <51241ED2.5080105@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/13 16:54, Alexander Holler wrote:
> Am 19.02.2013 23:54, schrieb Randy Dunlap:
>> On 02/19/2013 02:36 AM, Alexander Holler wrote:
>>> Am 19.02.2013 10:54, schrieb richard -rw- weinberger:
>>>> On Tue, Feb 19, 2013 at 10:40 AM, Alexander Holler
>>>> <holler@ahsoftware.de> wrote:
>>>>> Hello,
>>>>>
>>>>> until now I could successfully suppress my curiosity about those
>>>>> tip:foo
>>>>> messages, but as the bot (or one of them) has now catched me too, I
>>>>> want to
>>>>> ask what it is.
>>>>>
>>>>> Searching for "tip(-)bot" or similiar doesn't reveal some useful info
>>>>> (for
>>>>> obvious reasons). Could someone give me an URL to source or
>>>>> documentation
>>>>> about that tool so that I can enlight myself about it's meaning?
>>>>
>>>> AFAIK tip-bot is a set of shell scripts used by _T_glx, _I_ngo and
>>>> _P_eter. :)
>>>>
>>>
>>> So messages from tip-bot are just acknowledgments (like those from Greg)
>>> that a patch has found it's way into one of the trees, with the
>>> difference that tip-bot sends those acknowledgments to lkml too, whereas
>>> Greg's scripts send them only to involved parties and not the lkml?
>>
>> Yes, that is my understanding of it.
>>
> 
> Thanks a lot for clarification.
> 
> In the meanwhile I've found an article at lwn about the kernel development process which lists many of the git repositories used by various maintainers. And that list includes tip. ;)
> 
> So the reason for my ignorance was that I didn't know that tip is actually the name of a git repository used by the x86 maintainers.

I can understand that.

The kernel tree MAINTAINERS file says for X86:

X86 ARCHITECTURE (32-BIT AND 64-BIT)
M:	Thomas Gleixner <tglx@linutronix.de>
M:	Ingo Molnar <mingo@redhat.com>
M:	"H. Peter Anvin" <hpa@zytor.com>
M:	x86@kernel.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
S:	Maintained
F:	Documentation/x86/
F:	arch/x86/



-- 
~Randy
