Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163017Ab3DEWST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:18:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33550 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162999Ab3DEWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:18:15 -0400
Message-ID: <515F4DA3.2000000@suse.cz>
Date: Sat, 06 Apr 2013 00:18:11 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
References: <20130402142717.GH32241@suse.de> <20130402150651.GB31577@thunk.org> <20130402151436.GC31577@thunk.org> <20130403101925.GA7341@suse.de>
In-Reply-To: <20130403101925.GA7341@suse.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 12:19 PM, Mel Gorman wrote:
> On Tue, Apr 02, 2013 at 11:14:36AM -0400, Theodore Ts'o wrote:
>> On Tue, Apr 02, 2013 at 11:06:51AM -0400, Theodore Ts'o wrote:
>>>
>>> Can you try 3.9-rc4 or later and see if the problem still persists?
>>> There were a number of ext4 issues especially around low memory
>>> performance which weren't resolved until -rc4.
>>
>> Actually, sorry, I took a closer look and I'm not as sure going to
>> -rc4 is going to help (although we did have some ext4 patches to fix a
>> number of bugs that flowed in as late as -rc4).
>>
> 
> I'm running with -rc5 now. I have not noticed much interactivity problems
> as such but the stall detection script reported that mutt stalled for
> 20 seconds opening an inbox and imapd blocked for 59 seconds doing path
> lookups, imaps blocked again for 12 seconds doing an atime update, an RSS
> reader blocked for 3.5 seconds writing a file. etc.
> 
> There has been no reclaim activity in the system yet and 2G is still free
> so it's very unlikely to be a page or slab reclaim problem.

Ok, so now I'm runnning 3.9.0-rc5-next-20130404, it's not that bad, but
it still sucks. Updating a kernel in a VM still results in "Your system
is too SLOW to play this!" by mplayer and frame dropping.

3.5G out of 6G memory used, the rest is I/O cache.

I have 7200RPM disks in my desktop.

-- 
js
suse labs
