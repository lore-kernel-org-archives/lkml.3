Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaKZCHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:07:35 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:49747 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaKZCHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:07:34 -0500
Message-ID: <547535AC.3000204@atmel.com>
Date: Wed, 26 Nov 2014 10:06:36 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
        <linux-kernel@vger.kernel.org>, <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA
 size definitions
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com> <54745B2F.70003@samsung.com>
In-Reply-To: <54745B2F.70003@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sylwester and Mauro

On 11/25/2014 6:34 PM, Sylwester Nawrocki wrote:
> Hi Josh,
>
> On 25/11/14 09:54, Josh Wu wrote:
>> Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
>> The definitions are sorted by alphabet order.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>   include/media/v4l2-image-sizes.h | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
>> index 10daf92..c70c917 100644
>> --- a/include/media/v4l2-image-sizes.h
>> +++ b/include/media/v4l2-image-sizes.h
>> @@ -25,10 +25,19 @@
>>   #define QVGA_WIDTH	320
>>   #define QVGA_HEIGHT	240
>>   
>> +#define SVGA_WIDTH	800
>> +#define SVGA_HEIGHT	680
> I think this should be 600. With that fixed, for both patches:

Yes, right, It should be 600. It's my bad with such terrible typo here.

Hi, Mauro

I saw this patch is already merged in the media_tree. But not changing 
the SVGA_HEIGHT to 600.

Would it possible for you to re-modify this commit in the media_tree to 
fix the SVGA_HEIGHT as 600?
Or need I resend the patch or a fix for this?

Sorry for such an inconvinencie.

>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Thanks a again.

Best Regards,
Josh Wu
>
>>   #define SXGA_WIDTH	1280
>>   #define SXGA_HEIGHT	1024
>>   
>>   #define VGA_WIDTH	640
>>   #define VGA_HEIGHT	480
>>   
>> +#define UXGA_WIDTH	1600
>> +#define UXGA_HEIGHT	1200
>> +
>> +#define XGA_WIDTH	1024
>> +#define XGA_HEIGHT	768
>> +
>>   #endif /* _IMAGE_SIZES_H */
> --
> Regards,
> Sylwester

