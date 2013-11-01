Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3KAHr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:47:56 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:43302 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:47:55 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: uaccess.h: include
 "asm-generic/uaccess-unaligned.h"
Thread-Topic: [PATCH] arc: include: asm: uaccess.h: include
 "asm-generic/uaccess-unaligned.h"
Thread-Index: AQHOz83G/WSnEbST/0e59o8NYeGHlQ==
Date: Fri, 1 Nov 2013 07:47:10 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075153EC6@IN01WEMBXA.internal.synopsys.com>
References: <523E6274.3030602@asianux.com>
 <C2D7FE5348E1B147BCA15975FBA2307514DF30@IN01WEMBXA.internal.synopsys.com>
 <523FFB5F.4030501@asianux.com> <52678EFF.8090705@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA17m1Ng031170

On 10/23/2013 02:26 PM, Chen Gang wrote:
> Hello Maintainers:
>
> Is this patch OK, please help check when you have time.

Mainline commit cbf8b8ca3ec "btrfs: change extent-same to copy entire argument
struct" removed the usage of __put_user_unaligned hence this patch is no longer
needed.

Thx,
-Vineet

>
> Thanks.
>
> On 09/23/2013 04:27 PM, Chen Gang wrote:
>> On 09/23/2013 04:07 PM, Vineet Gupta wrote:
>>> On 09/22/2013 08:53 AM, Chen Gang wrote:
>>>> Need include the default implementation, just like another platforms
>>>> (e.g. parisc, tile ...), or can not pass compiling.
>>>>
>>>> The related error (with allmodconfig for arc):
>>>>
>>>>     CC [M]  fs/btrfs/ioctl.o
>>>>   fs/btrfs/ioctl.c: In function ï¿½btrfs_ioctl_file_extent_sameï¿½:
>>>>   fs/btrfs/ioctl.c:2802: error: implicit declaration of function ï¿½__put_user_unalignedï¿½
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> Acked-by: Vineet Gupta <vgupta@synopsys.com>
>>>
>> Thank you too.
>>
>>> Thx,
>>> -Vineet
>>>
>>>
>>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
