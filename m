Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3JRWpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:45:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34849 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757355Ab3JRWpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:45:30 -0400
Message-ID: <5261BA02.9050808@sgi.com>
Date: Fri, 18 Oct 2013 17:45:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Namjae Jeon <linkinjeon@gmail.com>, <viro@zeniv.linux.org.uk>,
        <mtk.manpages@gmail.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <bpm@sgi.com>, <elder@kernel.org>, <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>, <linux-kernel@vger.kernel.org>,
        <xfs@oss.sgi.com>, <a.sangwan@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com> <52616EC6.7030400@sgi.com> <20131018224404.GX4446@dastard>
In-Reply-To: <20131018224404.GX4446@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [134.15.128.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if there are others please let me know.

On 10/18/2013 05:44 PM, Dave Chinner wrote:
> On Fri, Oct 18, 2013 at 12:24:22PM -0500, Rich Johnston wrote:
>> This has been committed.
>>
>> Thanks
>> --Rich
>>
>> commit e64190f8440286a815060524777b435e06a7b364
>> Author: Namjae Jeon <namjae.jeon@samsung.com>
>> Date:   Sun Oct 6 20:13:38 2013 +0000
>>
>>      [RESEND, 4/7] xfsprogs: xfsio: add support
>> FALLOC_FL_COLLAPSE_RANGE for fallocate
>
> Hi Rich,
>
> This isn't ready for being committed into xfsprogs. The kernel code
> is still under review, and until we actually have it in a tree to be
> merged int eh kernel, we shoul d't be making any userspace changes
> at all. Indeed, there's a chance (unlikely, but still there) that
> this code may still not end up in the kernel at all...
>
> So, it's probably best right now to revert this patch until we have
> the fallocate API support merged into the kernel...
>
> Cheers,
>
> Dave.
>
