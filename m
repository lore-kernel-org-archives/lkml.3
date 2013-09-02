Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3IBUEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:04:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54756 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3IBUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:04:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5224EF32.5060104@roeck-us.net>
Date: Mon, 02 Sep 2013 13:04:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
References: <9976.1378132260@warthog.procyon.org.uk> <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf> <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com> <1378148367.1953.98.camel@joe-AO722> <20130902195056.GB32628@leaf>
In-Reply-To: <20130902195056.GB32628@leaf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 12:50 PM, Josh Triplett wrote:
> On Mon, Sep 02, 2013 at 11:59:27AM -0700, Joe Perches wrote:
>> On Mon, 2013-09-02 at 15:39 -0300, Mauro Carvalho Chehab wrote:
>>> Em Mon, 2 Sep 2013 11:19:01 -0700
>>> Josh Triplett <josh@joshtriplett.org> escreveu:
>> []
>>>> +# This file does not define the kernel coding style; Documentation/CodingStyle
>>>> +# does.  If you add a new style test to this file, add the corresponding style
>>>> +# rule it enforces to Documentation/CodingStyle.
>>
>>> Agreed with that.
>>
>> I do not.
>>
>>> I would also add another comment there: "in case of
>>> conflicts between checkpatch.pl and Documentation/CodingStyle, the latter
>>> takes precedence."
>>
>> There are many checkpatch rules (like semicolons) that
>> are not in CodingStyle.
>
> It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> not be enforcing style rules that aren't documented in CodingStyle.
>

Oddly enough, the opposite is true as well. 3.1, spaces around binary
and ternary operators, is for example not enforced, presumably because
it would generate too many positives. Since I like that rule, I have
my private version of checkpatch.pl which does check for it. After all,
it _is_ a CodingStyle rule.

Guenter

>> CodingStyle should not become some intensely detailed
>> document that specifies the "only one true way" to
>> write code.
>
> Any rule that maintainers are likely to enforce on patches they review
> should live in Documentation/CodingStyle; unwritten rules are a bad
> idea.  Any rule that maintainers are *not* likely to enforce shouldn't
> go in scripts/checkpatch.pl.
>


