Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3GXQ7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:59:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45768 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3GXQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:59:08 -0400
Message-ID: <51F0079D.8060300@infradead.org>
Date: Wed, 24 Jul 2013 09:58:05 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Rob Landley <rob@landley.net>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that hasn't
 changed
References: <20130723225715.GD31864@blackmetal.musicnaut.iki.fi> <1374621001.3031.1@driftwood> <CAP=VYLqvxctQCmTqrdhtgrc1Fr1bfFGG-xn1RA68vUW6yWyG6w@mail.gmail.com>
In-Reply-To: <CAP=VYLqvxctQCmTqrdhtgrc1Fr1bfFGG-xn1RA68vUW6yWyG6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 17:32, Paul Gortmaker wrote:
> On Tue, Jul 23, 2013 at 7:10 PM, Rob Landley <rob@landley.net> wrote:
>> On 07/23/2013 05:57:15 PM, Aaro Koskinen wrote:
>>>
>>> Hi,
>>>
>>> On Sun, Jul 21, 2013 at 01:12:55AM -0400, Paul Gortmaker wrote:
>>>> Looking at the bigger picture, the need for this file has simply
>>>> passed.  It was trying to detail required versions of userspace
>>>> packages, in order to cater to hand-crafted systems.  But now the
>>>> majority of users get their userspace all at once from some kind
>>>> of distro, and we are probably a lot more serious about avoiding
>>>> breaking userspace than we were a dozen years ago.
>>
>>
>> You're right, there's no such thing as "embedded linux", nobody creates
>> their own hand-crafted systems, or assembles cross-compiling environments to
>> target hardware other than x86. That's crazy talk.
> 
> Aside from the obvious sarcasm, what are you trying to say here?   The above
> seems like a classic strawman argument to me, since _none_ of the above are
> things that I have said or implied.   And if pressed, I can give many counter
> examples to drive that point home.  Do I really need to?
> 
>>
>>> Is there any file describing the needed tools (and minimum versions) to
>>> _build_ the kernel? I agree that trying to describe such for the run-time
>>> userspace does not belong to the kernel tree, but the required/supported
>>> versions of build tools should be still maybe documented...
>>
>>
>> Documentation/changes _is_ the file that describes the kernel's build-time
>> prerequisites. It hasn't changed in a while because we've been maintaining
>> backwards compatability, especially for several non-x86 targets where it's
>> fiddly to get newer toolchain versions.
> 
> See the mail from hpa --- what may be the "latest" for some less common
> arch may also be simply too old for another arch.  Hence this kind of stuff
> needs to be in an arch specific file, let alone not in a mis-named "Changes"
> file.
> 
>>
>> (Personally I use the last GPLv2 releases of each package, so gcc 4.2.1,
>> binutils 2.17, make 3.81, and busybox.)
> 
> And this works on every arch that linux supports?
> 
>>
>> I agree squashfs and such aren't build time prerequisites. It might make
>> more sense to move some of these to menuconfig text for the appropriate
>> option. But that's not the same as not documenting it at all, and "this
>> document has been true for a long time and remains true, therefore we must
>> discard it" strikes me as a really weird document retention criteria.
> 
> Again, a strawman.  You suggest I said the above with your "this document..."
> quote, but I never said anything like that, and it totally mis-represents why I
> suggested we should remove it.
> 
> Lets move forward from here and not descend into arguing over details.
> 
> To that end, if we create a required-packages.txt that covers the generic
> stuff like "make" version, and then the arch specific stuff (in arch specific
> files) for key stuff like gcc version, and gas version, etc, would you not
> see that as an improvement over what is currently in the mis-named and
> largely abandoned Changes file?

Yes, a list of required packages with their locations (URLs) and other
metadata would be both Good and Sufficient IMO.

Thanks.


-- 
~Randy
