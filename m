Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaKOOts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 09:49:48 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56892 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754009AbaKOOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 09:49:46 -0500
Message-ID: <546767FD.2080706@iki.fi>
Date: Sat, 15 Nov 2014 16:49:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:33.0) Gecko/20100101 SeaMonkey/2.30
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] Add RGB444_1X12 and RGB565_1X16 media bus formats
References: <1415961360-14898-1-git-send-email-boris.brezillon@free-electrons.com>	<20141114135831.GC8907@valkosipuli.retiisi.org.uk> <20141114160446.70c1b8b9@bbrezillon>
In-Reply-To: <20141114160446.70c1b8b9@bbrezillon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Boris Brezillon wrote:
> Hi Sakari,
> 
> On Fri, 14 Nov 2014 15:58:31 +0200
> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
>> Hi Boris,
>>
>> On Fri, Nov 14, 2014 at 11:36:00AM +0100, Boris Brezillon wrote:
...
>>> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
>>> index 23b4090..cc7b79e 100644
>>> --- a/include/uapi/linux/media-bus-format.h
>>> +++ b/include/uapi/linux/media-bus-format.h
>>> @@ -33,7 +33,7 @@
>>>  
>>>  #define MEDIA_BUS_FMT_FIXED			0x0001
>>>  
>>> -/* RGB - next is	0x100e */
>>> +/* RGB - next is	0x1010 */
>>>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>>>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
>>>  #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
>>> @@ -47,6 +47,8 @@
>>>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
>>>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
>>>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
>>> +#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
>>> +#define MEDIA_BUS_FMT_RGB565_1X16		0x100f
>>
>> I'd arrange these according to BPP and bits per sample, both in the header
>> and documentation.
> 
> I cannot keep both macro values and BPP/bits per sample in incrementing
> order. Are you sure you prefer to order macros in BPP/bits per sample
> order ?

If you take a look elsewhere in the header, you'll notice that the
ordering has preferred the BPP value (and other values with semantic
significance) over the numeric value of the definition. I'd just prefer
to keep it that way. This is also why the "next is" comments are there.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
