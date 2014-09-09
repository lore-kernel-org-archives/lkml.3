Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaIIMKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:10:25 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:50268 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaIIMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:10:23 -0400
Message-ID: <540EEE2C.1090801@plexistor.com>
Date: Tue, 09 Sep 2014 15:10:20 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <54044759.9080103@gmail.com>
In-Reply-To: <54044759.9080103@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 01:15 PM, Boaz Harrosh wrote:
> On 08/27/2014 06:22 PM, Boaz Harrosh wrote:
>> Jens Hi
>>
>> What do you intend to do with these fixes? These are real bugs on devices
>> shipped for a while now. I think they need to go into current 3.17-rcX Kernel.
>>
> 
> Jens hi
> 
> I have seen that the brd patch went into rc3.
> 
> I should insist then, that these patches go into this rc cycle ASAP.
> For one they fix real *hard* unexpected bugs with brd that make it trash data.
> 
> But specially because the patch to brd that just went into Kernel introduces
> a wrong module parameter "show_part" which must be removed. If we release a Kernel
> with it, it will be pain, we will need to deprecate it which is long and annoying
> procedure. It is wrong because it must be always on. Pleas see below
> 
> This patchset is based on what just went into Kernel.
> Also on git here: git://git.open-osd.org/pmem.git brd-partitions branch
> 
> [http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=shortlog;h=refs/heads/brd-partitions]
> 
> Thanks
> Boaz
> 
<>
>> list of patches:
>> [PATCH 1/5] axonram: Fix bug in direct_access
>> [PATCH 2/5] Change direct_access calling convention
<>
>> [PATCH 3/5] brd: Add getgeo to block ops
<>
>> [PATCH 4/5] brd: Fix all partitions BUGs
>> [PATCH 5/5] brd: Request from fdisk 4k alignment

Ping Jens?

Please tell me what you want to do with these patches. They must go into this Kernel
cycle before brd is released with wrong user-mode visible nub

If you want you can drop the [PATCH 3/5] which is not important and can go in next
cycle, but the others are real BUG fixes.

Thanks
Boaz

