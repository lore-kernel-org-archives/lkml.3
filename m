Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3EQFKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 01:10:46 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:65368 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3EQFKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 01:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <1561290.MnyCnpJz5W@avalon>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368709102-2854-2-git-send-email-prabhakar.csengg@gmail.com> <1561290.MnyCnpJz5W@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 May 2013 10:40:24 +0530
Message-ID: <CA+V-a8sCk2STGuEJnyp99yA218UzZFXp0aXAdQOVkZzZmG8msg@mail.gmail.com>
Subject: Re: [PATCH 1/7] media: davinci: vpif: remove unwanted header includes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thu, May 16, 2013 at 6:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Thursday 16 May 2013 18:28:16 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpif.c |    7 -------
>>  1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif.c
>> b/drivers/media/platform/davinci/vpif.c index ea82a8b..d354d50 100644
>> --- a/drivers/media/platform/davinci/vpif.c
>> +++ b/drivers/media/platform/davinci/vpif.c
>> @@ -17,18 +17,11 @@
>>   * GNU General Public License for more details.
>>   */
>>
>> -#include <linux/init.h>
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>> -#include <linux/spinlock.h>
>> -#include <linux/kernel.h>
>> -#include <linux/io.h>
>> -#include <linux/err.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/v4l2-dv-timings.h>
>
> I think you should keep most of those includes. For instance this file uses
> spinlock functions, so linux/spinlock.h should be included. It might work fine
> now due to nested includes, but if someone reorganizes the kernel headers
> internal includes then the driver might break. As a general rule of good
> practice you should include headers for all the APIs you use.
>
OK, do you want me too drop the similar patches from this series ?

Regards,
--Prabhakar Lad
