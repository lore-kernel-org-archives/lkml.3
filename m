Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaCIAYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 19:24:15 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61517 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaCIAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 19:24:14 -0500
Message-ID: <531BB4A9.5000305@kernel.dk>
Date: Sat, 08 Mar 2014 17:24:09 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
CC: Mike Snitzer <snitzer@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix q->flush_rq NULL pointer crash on dm-mpath
 flush
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com> <531B8CB1.2010502@suse.de> <20140308220926.GA15421@redhat.com>
In-Reply-To: <20140308220926.GA15421@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-08 15:09, Mike Snitzer wrote:
> On Sat, Mar 08 2014 at  4:33pm -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> On 03/08/2014 07:13 PM, Mike Snitzer wrote:
>>>
>>> I'm calm.. was just a bit frustrated.  But this isn't a big deal.
>>> I'll make an effort to reach out to relevant people sooner when
>>> similar stuff is reported against recently upstreamed code.  Would be
>>> cool if you did the same.  I can relate to needing to have the distro
>>> vendor hat on (first needing to determine/answer "is this issue
>>> specific to our hacked distro kernel?", etc).
>>>
>> The patch I made wasn't in the context of 'recently upstreamed
>> code', it was due to a backport Jan Kara did for our next distro
>> kernels (3.12-based).
>
> "3.12-based" means nothing given all the backporting for SLES, much like
> "3.10-based" means nothing in the context of RHEL7.
>
> The only way this fix is applicable is in the context of "recently
> upstreamed code", commit 1874198 ("blk-mq: rework flush sequencing
> logic") went upstream for v3.14-rc3.
>
> Jens, please feel free to queue this tested fix for 3.14-rc:

Thanks Mike, queued up. Also queued up the list addition reversal change.

-- 
Jens Axboe

