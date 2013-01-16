Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3APRIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:08:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43478 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3APRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:08:49 -0500
Message-ID: <50F6DE9D.5080906@wwwdotorg.org>
Date: Wed, 16 Jan 2013 10:08:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Tony Prisk <linux@prisktech.co.nz>, Stephen Warren <swarren@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Colin Cross <ccross@android.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc tree
References: <20130116141411.8fadedee54ed35dc0eddd288@canb.auug.org.au> <1358308153.32106.8.camel@gitbox> <50F62D69.8080100@nvidia.com> <1358311923.537.3.camel@gitbox> <CAOesGMgr_f-XGHOdMW3ugfXbVaUc4EALrbfJD=XeOKixxrY8PA@mail.gmail.com>
In-Reply-To: <CAOesGMgr_f-XGHOdMW3ugfXbVaUc4EALrbfJD=XeOKixxrY8PA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 09:27 AM, Olof Johansson wrote:
> Hi,
> 
> On Tue, Jan 15, 2013 at 8:52 PM, Tony Prisk <linux@prisktech.co.nz> wrote:
>> On Tue, 2013-01-15 at 21:32 -0700, Stephen Warren wrote:
>>> On 01/15/2013 08:49 PM, Tony Prisk wrote:
>>>> On Wed, 2013-01-16 at 14:14 +1100, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Today's linux-next merge of the tegra tree got a conflict in
>>>>> drivers/clocksource/Makefile between commit ff7ec345f0ec ("timer: vt8500:
>>>>> Move timer code to drivers/clocksource") from the arm-soc tree and commit
>>>>> ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
>>>>> the tegra tree.
>>>>>
>>>>> I fixed it up (see below) and can carry the fix as necessary (no action
>>>>> is required).
>>>>>
>>>>
>>>> I don't know about everyone else, but I feel the preference should be to
>>>> keep things alphabetized where possible to help avoid with merge
>>>> conflicts later on. This is always a problem when we start tacking
>>>> things on the end of lists.
>>>>
>>>> I realise this Kconfig is not alphabetized anyway, but it's never too
>>>> early to start on the 'right' path.
>>>
>>> Sounds like a good idea, but the issue is: When to do the initial sort
>>> so it doesn't conflict with all the adds in a kernel cycle... Post and
>>> immediately commit a new patch near the end of the merge window?
>>
>> Given that the maintainer can quite safely do the patch (sorry
>> maintainers), I don't see any reason why it couldn't be done at the
>> point where they stop accepting patches for the merge-window. Once the
>> patches are stopped, sort the list in one last patch.

That only works well if the one maintainer is the only person taking
patches for the drivers/clocksource tree. It might be true that the "one
maintainer" here ends up being arm-soc in this kernel cycle though?

>> It makes sense to get it done in this window if possible as the Kconfig
>> will only get bigger as time goes on, making sorting it more time
>> consuming.
> 
> Actually, Russell wen through and reordered these not long ago, if I
> remember correctly. The current ordering is the same as in the
> structure definition, and should be kept that way.

I think this is talking about Makefile entries rather than struct
definitions?
