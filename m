Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaB0BwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:52:07 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43866 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754329AbaB0BwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:52:05 -0500
Message-ID: <530E9A43.5030003@hurleysoftware.com>
Date: Wed, 26 Feb 2014 20:52:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
References: <530E6F76.1070605@zytor.com> <20140226232859.GA9213@kroah.com> <530E82B2.3040305@zytor.com>
In-Reply-To: <530E82B2.3040305@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 07:11 PM, H. Peter Anvin wrote:
> On 02/26/2014 03:28 PM, Greg KH wrote:
>>>
>>> What do we need to do to actually make our tools be able to do work for
>>> us?  Newbie projects to clean up?  Trying to get the larger Linux
>>> companies to put resources on it?
>>
>> It's not the easiest "newbie" project as usually the first reflex to
>> "just cast it away" is wrong for a lot of sparse warnings.  I know this
>> from people trying to fix up the sparse warnings in drivers/staging/
>>
>
> I have seen this phenomenon, too.  I also see a bunch of sparse warnings
> which are clearly bogus, for example complaining about sizeof(bool) when
> in bits like:
>
> 		__this_cpu_write(swallow_nmi, false);
>
> So getting this to the point where it is genuinely useful and can be
> made a ubiquitous part of the Linux development process is going to take
> more work and probably involve improvements to sparse so we can indicate
> in the kernel sources when something is okay or removing completely
> bogus warnings, and so on.
>
> The bigger question, again, is what do we need to do to make this
> happen, assuming it is worth doing?  We certainly have had bugs,
> including security holes, which sparse would have caught.  At the same
> time, this kind of work tends to not be the kind that attract the top
> hackers, unfortunately, as it is not "fun".

Well there was that "should we do a bug-fix-only 4.0 release?" message
from Linus back at the 3.12 release.

Or do like Geert does with the build message regressions/fixes. I always scan
that to make sure none of my work is in it :)  (And that could be chunked
up by maintainer).

Just a thought.

Regards,
Peter Hurley
