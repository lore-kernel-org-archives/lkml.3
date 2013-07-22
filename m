Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3GVPnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:43:17 -0400
Received: from mout1.fh-giessen.de ([212.201.18.42]:53596 "EHLO
	mout1.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab3GVPnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:43:16 -0400
Message-ID: <51ED5311.7070200@mni.thm.de>
Date: Mon, 22 Jul 2013 17:43:13 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Thunderbird/25.0a1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <51EC4D77.2010502@mni.thm.de> <2494093.OzngazxDQW@vostro.rjw.lan>
In-Reply-To: <2494093.OzngazxDQW@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.2013 15:08, Rafael J. Wysocki wrote:
> On Sunday, July 21, 2013 11:07:03 PM Tobias Klausmann wrote:
>> On 21.07.2013 21:53, Linus Torvalds wrote:
>>> So it's been another week, and -rc2 is out there.
>> ...
>>>    (b) we had a late change to how ACPI backlight handling is done on
>>> certain machines, and while this kind of thing really shouldn't be
>>> done outside the merge window, I ended up pulling it anyway. But I'd
>>> *really* like to have people test this thing particularly on laptops
>>> with intel-based graphics. It should only matter (and hopefully
>>> improve things) for the newer ones with BIOSes designed for Windows 8,
>>> but hey, the more testing, the better. Backlight handling has been
>>> painful before, so I'm mentioning this explicitly.
>>>
>> This pach finally fixes my backlight control!
> Yes, it fixes that for a number of people, which is the reason why I send
> the pull request in the first place, but it also turns out to break things
> for some people and therefore it'll have to be reverted.
>
> We're still going to work on that, though.
>
> Thanks,
> Rafael
>
>
If you have new patches ready for this and you want them to be tested, 
let me know!

Thanks,
Tobias
