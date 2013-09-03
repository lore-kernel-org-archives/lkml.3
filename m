Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3ICJHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:07:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54063 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3ICJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:07:21 -0400
X-Spam-Score: -100.9
Message-ID: <5225A685.5040507@asianux.com>
Date: Tue, 03 Sep 2013 17:06:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] block/ioctl.c: let code match 'kernel code style'
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com> <52208DFD.20105@roeck-us.net> <52240566.3040201@asianux.com> <52259DDE.6070401@asianux.com> <5225A3F8.5070008@huawei.com>
In-Reply-To: <5225A3F8.5070008@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 04:55 PM, Li Zefan wrote:
> Please don't. Pure colding style cleanup is discouraged.
> 

Pardon?

Do you mean "coding style", not "colding style"? (or it is my
misunderstanding?).


> You're not going to run checkpatch.pl on the whole kernel tree and fix
> all the complaints, are you?
> 

I am not going to, it seems that may be the 'job' of Joe and
trivial@kernel.org?


BTW: it seems you did not redirect my mails to "/dev/null".  ;-)

Thanks.

> On 2013/9/3 16:29, Chen Gang wrote:
>> For 'switch case', remove redundancy '\t' (also can let related lines
>> within 80 columns) and remove redundancy empty lines, just like other
>> 'switch case' which match 'kernel code style' within the file.
>>
>> Let blkpg_ioctl() within 80 columns. Let 2nd line of blkdev_ioctl() and
>> __blkdev_driver_ioctl() align 1st line parameter's start position, just
>> like blk_ioctl_discard() and blk_ioctl_zeroout() within the file.
>>
>> For is_unrecognized_ioctl(), can shrink the 'return' statement into one
>> line (so can save 2 lines), it still matches 'kernel code style' and it
>> is no conflict with others within the file.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  block/ioctl.c |  216 ++++++++++++++++++++++++++++-----------------------------
>>  1 files changed, 105 insertions(+), 111 deletions(-)
> 
> 
> 


-- 
Chen Gang
