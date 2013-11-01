Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3KAH6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:58:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34771 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3KAH6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:58:33 -0400
X-Spam-Score: -100.8
Message-ID: <52735EEA.1050800@asianux.com>
Date: Fri, 01 Nov 2013 15:57:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: uaccess.h: include "asm-generic/uaccess-unaligned.h"
References: <523E6274.3030602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DF30@IN01WEMBXA.internal.synopsys.com> <523FFB5F.4030501@asianux.com> <52678EFF.8090705@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075153EC6@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075153EC6@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 03:47 PM, Vineet Gupta wrote:
> On 10/23/2013 02:26 PM, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Is this patch OK, please help check when you have time.
> 
> Mainline commit cbf8b8ca3ec "btrfs: change extent-same to copy entire argument
> struct" removed the usage of __put_user_unaligned hence this patch is no longer
> needed.
> 

Thank you for your careful checking!!


> Thx,
> -Vineet
> 
>>
>> Thanks.
>>
>> On 09/23/2013 04:27 PM, Chen Gang wrote:
>>> On 09/23/2013 04:07 PM, Vineet Gupta wrote:
>>>> On 09/22/2013 08:53 AM, Chen Gang wrote:
>>>>> Need include the default implementation, just like another platforms
>>>>> (e.g. parisc, tile ...), or can not pass compiling.
>>>>>
>>>>> The related error (with allmodconfig for arc):
>>>>>
>>>>>     CC [M]  fs/btrfs/ioctl.o
>>>>>   fs/btrfs/ioctl.c: In function �btrfs_ioctl_file_extent_same�:
>>>>>   fs/btrfs/ioctl.c:2802: error: implicit declaration of function �__put_user_unaligned�
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> Acked-by: Vineet Gupta <vgupta@synopsys.com>
>>>>
>>> Thank you too.
>>>
>>>> Thx,
>>>> -Vineet
>>>>
>>>>
>>>
>>
> 


-- 
Chen Gang
