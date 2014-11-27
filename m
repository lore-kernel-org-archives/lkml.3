Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaK0DVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:21:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:43005 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaK0DVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:21:17 -0500
Message-ID: <547698A6.3090703@atmel.com>
Date: Thu, 27 Nov 2014 11:21:10 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA
 size definitions
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1411252318330.17362@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1411252318330.17362@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi

On 11/26/2014 6:23 AM, Guennadi Liakhovetski wrote:
> Hi Josh,
>
> On Tue, 25 Nov 2014, Josh Wu wrote:
>
>> Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
>> The definitions are sorted by alphabet order.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Thanks for your patches. I'm ok with these two, but the second of them
> depends on the first one, and the first one wouldn't (normally) be going
> via the soc-camera tree. Mauro, how would you prefer to handle this?
> Should I pick up and push to you both of them or postpone #2 until the
> next merge window?

The first patch is already merged in the media_tree. If the soc-camera 
tree will be merged to the media_tree, then there should have no 
dependency issue.
Am I understanding correct?

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
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
>> +
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
>> -- 
>> 1.9.1
>>

