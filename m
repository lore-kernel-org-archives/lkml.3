Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3ASMdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:33:13 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:52239 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3ASMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:33:11 -0500
Message-ID: <50FA9277.8030509@synopsys.com>
Date: Sat, 19 Jan 2013 18:02:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <arnd@arndb.de>
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <20121120134737.GB8111@elf.ucw.cz> <20121120135901.GA9227@elf.ucw.cz> <50AB9116.3090401@synopsys.com> <20130118194631.GA5119@amd.pavel.ucw.cz>
In-Reply-To: <20130118194631.GA5119@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013 01:16 AM, Pavel Machek wrote:
> On Tue 2012-11-20 19:47:58, Vineet Gupta wrote:
>> On Tuesday 20 November 2012 07:29 PM, Pavel Machek wrote:
>>> On Tue 2012-11-20 14:47:37, Pavel Machek wrote:
>>>> Hi!
>>>>
>>>>>     https://raw.github.com/vineetgarc/publish/master/ELCE-2012-ARC-Linux.pdf
>>>>>
>>>>> All comments/criticisms are welcome !
>>>> Huh. arch/arc is very similar to arch/arm. So similar that it took me
>>>> 10 minutes to figure out. I guess theres no alternate name arc could
>>>> use?
>>> Hmm... "Advanced Risc"... :-(.
>>>
>>> Ok, plus there's already computing standard called "arc".
>>>
>>> https://www.linux-mips.org/wiki/ARC
>>>
>>> What about calling the architecture "sarc" or "syarc" ?
>> I think it would be best use of everybody's time if you could focus on
>> the technical content of the port rather than the name. It has been like
>> that for +10 years and I don't intend to make the kernel port name
>> different from THE arch name itself.
> Yeah, and it is best use of reviewers time to confuse them with
> one-letter difference to very popular architecture... and use three
> letter acronym that was already taken.
>
> In this state, I hope your port never gets merged. Yes, I got used to
> do cd a<tab>/ar<tab>.
> 									Pavel

Although I really don't want to spend time arguing with you but still ...... if
you had a neighbor with same name as your friend your strategy most likely would
be to force one of them to change names - kind of seems funny and stupid.

Having said that, despite all the ranting so far, you've not managed to comment on
a single line of the actual code, which is more funny and stupid. So please stop
blathering and do some constructive work. I won't go around asking ARC name to be
changed because someone's Tab completion doesn't work anymore.

And I'm sorry dude, that alone won't prevent the port from being merged.

-Vineet

