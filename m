Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaHYHRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:17:41 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:54109 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaHYHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:17:39 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: "jic23@kernel.org" <jic23@kernel.org>, gregkh <gregkh@linuxfoundation.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:iio: moved platform_data into include/linux/iio
Thread-Topic: [PATCH] staging:iio: moved platform_data into include/linux/iio
Thread-Index: AQHPvD/0dxnEQqo0D0eqpJHW9TvQ6ZvY+PeAgAACRoCAAAFvgIAH85xQ
Date: Mon, 25 Aug 2014 07:17:33 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF3CC4B@EU-MBX-04.mgc.mentorg.com>
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
	<53F441FF.9090304@metafoo.de>
 <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com>
 <53F4451B.3040209@metafoo.de>
In-Reply-To: <53F4451B.3040209@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Aug 2014 07:17:37.0836 (UTC) FILETIME=[A6538EC0:01CFC034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7P7HjHM024757

Hello Lars,

As per your suggestion Can I move complete Driver out of staging specially SPI ADC Driver.

Regards
Sanjeev Sharma

-----Original Message-----
From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
Sent: Wednesday, August 20, 2014 12:20 PM
To: sanjeev sharma
Cc: Sharma, Sanjeev; jic23@kernel.org; gregkh; linux-iio@vger.kernel.org; devel; linux-kernel
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio

On 08/20/2014 08:44 AM, sanjeev sharma wrote:
> Hi,
>
> This was the action item(TO-DO). IMO, it make sense to move into 
> include/linux/iio because IIO complete subsystem may take some time.

The code that is in staging is not supposed to 'leak' outside of staging. So either you move the driver as a whole out of staging or leave it there, but do not move individual files of the driver out of staging. The action item is for when the driver is moved out of staging.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
