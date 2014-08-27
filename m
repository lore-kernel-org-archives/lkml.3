Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935328AbaH0P5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:57:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44390 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935055AbaH0P5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:57:11 -0400
Message-ID: <53FDFFD0.8090503@plexistor.com>
Date: Wed, 27 Aug 2014 18:57:04 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dmitry Monakhov <dmonakhov@openvz.org>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <87wq9u7x77.fsf@openvz.org>
In-Reply-To: <87wq9u7x77.fsf@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 06:45 PM, Dmitry Monakhov wrote:
> On Wed, 27 Aug 2014 18:22:21 +0300, Boaz Harrosh <boaz@plexistor.com> wrote:
<>
>> [v2]
>> Based on Jens's linux-next [30e996a] incorporating the brd patch by Dmitry Monakhov.
>> Dmitry has introduced a new part_show parameter, this parameter is now
>> removed
>   In which commit or kernel-tree this parameter was removed?

I mean after this patchset, see patch
	[PATCH 4/5] brd: Fix all partitions BUGs

It will remove this param

>> and we always "part_show=1".
>> Scripts that did part_show=1 will work just the same but will display a
>> message in logs. This is harmless. (And scripts can be modified to
>> remove this parameter)
>   Which script are you talking about? Why you want use it?
> 

I meant that if any user-mode code was doing
	modprobe brd part_show=1
Then this "part_show=1" is now deprecated and can be removed

Though the part_show=1 has not yet been released in any kernel
and it is a very low chance that any one had a chance to
use it

Thanks
Boaz


