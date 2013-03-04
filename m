Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3CDCbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:31:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:38811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3CDCbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:31:46 -0500
Message-ID: <513407AC.8060009@infradead.org>
Date: Sun, 03 Mar 2013 18:32:12 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <alpine.LRH.2.00.1303040213590.11934@twin.jikos.cz> <CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
In-Reply-To: <CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/13 17:42, Linus Torvalds wrote:
> On Sun, Mar 3, 2013 at 5:17 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>>
>> I actually quite liked your merge shortlog, which of course I can generate
>> easily myself, but it was nice to have for free :)
> 
> No, you're right, I should do it. In fact, I should automate it better
> so that I do it by default and don't have to do so much hand-editing
> of the result of a (really) stupid shell script.
> 
> It's all based on just
> 
>     git log v3.8.. --author=Torvalds --merges |
>         egrep '^    ((Merge)|(Pull)) .* from '
> 
> and then some nasty sed+sort crud, followed by some manual fixup. It's
> the kind of thing perl is perfect for, but I'm not much of a perl
> person, so I have never written a *good* script to just do this right.
> 
> Anyway, here it is, the merge-log of stuff that happened in the merge
> window for 3.9.
> 
>                    Linus
> 
> ---

I suppose that this omits individual contributor patches by design?
I had 3 patches merged, but they are hidden by this method.


> James Bottomley:
>         first round of SCSI updates
>         SCSI updates

1 here

> Wim Van Sebroeck:
>         watchdog updates

1 here

and 1 merged by Linus Torvalds.


thanks,
-- 
~Randy
