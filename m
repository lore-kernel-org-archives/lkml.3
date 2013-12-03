Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3LCR0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:26:42 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57934 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3LCR0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:26:37 -0500
Message-ID: <529E1447.5070903@gmail.com>
Date: Wed, 04 Dec 2013 01:26:31 +0800
From: Peng Tao <bergwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 7/9] staging/lustre/llite: remove ll_file_get_iov_count
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com> <1386081729-9481-10-git-send-email-bergwolf@gmail.com> <20131203170028.GA9063@kroah.com>
In-Reply-To: <20131203170028.GA9063@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 01:00 AM, Greg Kroah-Hartman wrote:
> On Tue, Dec 03, 2013 at 10:42:06PM +0800, Peng Tao wrote:
>> It exactly copies generic_segment_checks() except wrongly calling
>> access_ok(VERIFY_READ) for aio read range. Drop it and just call
>> generic_segment_checks() instead.
>>
>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>> ---
>>   drivers/staging/lustre/lustre/llite/file.c |   36 ++--------------------------
>>   1 file changed, 2 insertions(+), 34 deletions(-)
>
> This patch breaks the build, in numerous ways, which means you didn't
> even build test this patch.
>
> PLEASE be more careful, it's getting such that I really dread seeing
> these patches show up in my inbox...
I am truly sorry. This one was added in the last and got in the middle 
after I reordered the series. Then I was under the impression that it 
was included when I tested the code. Really sorry for causing the 
trouble. I will be more careful.

I'll fix up and resend the rest of the series. Sorry for the noise.

Thanks,
Tao



