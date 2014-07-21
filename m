Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaGUUpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:45:36 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:59384 "EHLO
	Ishtar.hs.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbaGUUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:45:35 -0400
Message-ID: <53CD7BE2.3040909@tlinx.org>
Date: Mon, 21 Jul 2014 13:45:22 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Howto tell kernel to use 4096 as granularity & minimum size?
References: <53CC0EAA.2010202@tlinx.org> <20140720222818.GM4453@dastard>
In-Reply-To: <20140720222818.GM4453@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
>
>> I can partition the disk and setup the allocation size
>> to 4096, but I'd like to tell the kernel to use a
>> virtual-size of 4096 for the sector as an additional
>> performance 'hint', so nothing will even try to use
>> smaller i/o's than that.
>>     
>
> Just format the filesystem with 4k sector size.
---
    Good idea,  though.. I wanted to set it for the whole "disk"(array)
as it (multiple 4T drives) will be subdivided into multiple filesystems
and have lvm and a partition table under the file system(s),
so telling the kernel to only do 4K alloc+io's to the whole thing
would cover the most with the least.




