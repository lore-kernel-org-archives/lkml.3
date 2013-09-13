Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3IMGfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:35:25 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:51346 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3IMGfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:35:24 -0400
Message-ID: <5232B219.5020603@hibox.fi>
Date: Fri, 13 Sep 2013 09:35:05 +0300
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <20130224012052.GC1196@thunk.org> <512D01E0.7010009@hibox.fi> <20130226231703.GA22674@quack.suse.cz> <5231BA3C.2090704@hibox.fi> <20130912131051.GA14664@quack.suse.cz> <5231C5FF.3060504@hibox.fi> <20130912143941.GB14664@quack.suse.cz> <5231D8DD.5010703@hibox.fi> <20130912163530.GD14664@quack.suse.cz> <523200EB.7000202@hibox.fi> <20130912204647.GA6826@quack.suse.cz>
In-Reply-To: <20130912204647.GA6826@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.2013 23:46, Jan Kara wrote:
> On Thu 12-09-13 20:59:07, Marcus Sundman wrote:
>> On 12.09.2013 19:35, Jan Kara wrote:
>>> On Thu 12-09-13 18:08:13, Marcus Sundman wrote:
>>>> And can I somehow "reset" whatever it is that is making it worse so
>>>> that it becomes good again? That way I could spend maybe 1 hour once
>>>> every few months to get it back to top speed.
>>>> Any other ideas how I could make this (very expensive and fairly new
>>>> ZenBook) laptop usable?
>>>    Well, I believe if you used like 70% or less of the disk and regularly
>>> (like once in a few days) run fstrim command, I belive the disk performance
>>> should stay at a usable level.
>> At 128 GB it is extremely small as it is, and I'm really struggling
>> to fit all on it. Most of my stuff is on my NAS (which has almost 10
>> TB space), but still I need several code repositories and the
>> development environment and a virtual machine etc on this tiny 128
>> GB thing.
>    I see. I have like 70 GB disk and 50% of it are free :) But I have test
> machines with much larger drives where I have VMs etc. This one is just
> for email and coding.
>
>> So, if I used some other filesystem, might that allow me to use a
>> larger portion of the SSD without this degradation? Or with a much
>> slower rate of degradation?
>    You might try f2fs. That is designed for low end flash storage so it
> might work better than ext4. But it is a new filesystem so backup often.
>
>> And at some point it will become unusable again, so what can I do
>> then? If I move everything to my NAS (and maybe even re-create the
>> filesystem?) and move everything back, might that get rid of the FTL
>> fragmentation?
>    Yes, that should get rid of it. But since you have only a few GB free,
> I'm afraid the fragmentation will reappear pretty quickly. But I guess it's
> worth a try.
>
>> Or could I somehow defragment the FTL without moving away everything?
>    I don't know about such way.

How about triggering the garbage collection on the drive, is that possible?


- Marcus

