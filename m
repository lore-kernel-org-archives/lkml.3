Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaGDJPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:15:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45954 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:15:01 -0400
Message-ID: <53B6708E.5030106@suse.cz>
Date: Fri, 04 Jul 2014 11:14:54 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz> <1403694435-3180-5-git-send-email-jslaby@suse.cz> <20140625134212.4fb38e14@alan.etchedpixels.co.uk> <53ABD8FB.9000700@suse.cz> <alpine.LNX.2.00.1406261030210.15939@pobox.suse.cz> <20140627191845.GA1408@xo-6d-61-c0.localdomain>
In-Reply-To: <20140627191845.GA1408@xo-6d-61-c0.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 09:18 PM, Pavel Machek wrote:
>>> This now writes:
>>> +       help
>>> +         Select this to enable kGraft online kernel patching. The
>>> +         runtime price is nearly zero, so it is safe to say Y here
>>> +         provided you are aware of all the consequences (e.g. in
>>> +         security).
>>>
>>> Is it OK with you?
>>
>> This might cause a false impression that we are actually opening a 
>> security hole into a system, which is not true at all.
>>
>> Yes, backdoor writeres might (or might not) make use of kGraft API, but 
>> they have gazillion of other comparable options (*probes, ftrace, 
>> text_poke(), ...).
>>
>> I'd perhaps propose something like
>>
>> "Select this to enable kGraft live kernel patching. The runtime penalty is 
>> nearly zero, so it is safe to say Y here if you want the kernel to expose 
>> API for live patching to modules".
> 
> Well. People that are not distro vendors will not prepare patches for
> themselves, right?

Hi, why do you believe so? But it is not so important, see below.

> And patches prepared for suse will not work on
> self-configured kernels.
> 
> So probably everyone should say "N" here...

The text is formulated correctly and satisfies your concerns, I think.
Say Y, if you want the API...

thanks,
-- 
js
suse labs
