Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3IOTT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 15:19:58 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:55301 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3IOTT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 15:19:57 -0400
Message-ID: <5236084D.3060509@hibox.fi>
Date: Sun, 15 Sep 2013 22:19:41 +0300
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <20130224012052.GC1196@thunk.org> <512D01E0.7010009@hibox.fi> <20130226231703.GA22674@quack.suse.cz> <5231BA3C.2090704@hibox.fi> <20130912131051.GA14664@quack.suse.cz> <5231C5FF.3060504@hibox.fi> <20130912143941.GB14664@quack.suse.cz> <5231D8DD.5010703@hibox.fi> <20130912163530.GD14664@quack.suse.cz> <523200EB.7000202@hibox.fi> <20130914024108.GA10740@thunk.org>
In-Reply-To: <20130914024108.GA10740@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2013 05:41, Theodore Ts'o wrote:
> On Thu, Sep 12, 2013 at 08:59:07PM +0300, Marcus Sundman wrote:
>> At 128 GB it is extremely small as it is, and I'm really struggling
>> to fit all on it. Most of my stuff is on my NAS (which has almost 10
>> TB space), but still I need several code repositories and the
>> development environment and a virtual machine etc on this tiny 128
>> GB thing.
>>
>> So, if I used some other filesystem, might that allow me to use a
>> larger portion of the SSD without this degradation? Or with a much
>> slower rate of degradation?
> What model are you using?  It's possible that your flash device was
> designed as a cache driver for windows.  As such, it might have been
> optimized for a read-mostly workload and not something for a lot of
> random small writes.

It's a SanDisk SSD U100.

> The f2fs file system is designed for crappy flash drives with crappy
> FTL's, so it might work be better for you.

OK, I'll probably try it when I have time to switch.

> But let me ask you this
> --- how much is your data worth?  How much would it cost to replace
> your flash device with something better?

A lot. I have lsyncd running here most of the time, backing up to my 
raid-z NAS which in turn uses a versioned off-site backup system.
Anyway, this is an Asus ZenBook computer and can't be opened. Well, it 
can, but that will void the warranty at the very least.


- Marcus

