Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaHHPTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:19:37 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:41473 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbaHHPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <1407508946.4915.10.camel@mtksdaap41>
References: <1407505411-2207-1-git-send-email-srv_yingjoe.chen@mediatek.com>
	<1407505411-2207-3-git-send-email-srv_yingjoe.chen@mediatek.com>
	<CABuKBeL-dcs+pDW3jUeRWNijyYwx4VUdUB=CjGXoGmQUCifQ5Q@mail.gmail.com>
	<1407508946.4915.10.camel@mtksdaap41>
Date: Fri, 8 Aug 2014 17:19:34 +0200
Message-ID: <CABuKBeKsEHc3wi60FACFz+sUaVZMx9o=j8a+avQq5DsFHJMj+A@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] arm: mediatek: Add support for GIC interrupt
 polarity extension.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Jonas Jensen <jonas.jensen@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
	<eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-08 16:42 GMT+02:00 Joe.C <srv_yingjoe.chen@mediatek.com>:
> On Fri, 2014-08-08 at 16:19 +0200, Matthias Brugger wrote:
>> 2014-08-08 15:43 GMT+02:00 Joe.C <srv_yingjoe.chen@mediatek.com>:
>> > From: "Joe.C" <yingjoe.chen@mediatek.com>
>> >
>> > Mediatek SoCs have an interrupt polarity extension which allows
>> > to swap the polarity for given interrupts.
>>
>> Please use ./script/checkpatch.pl, all 4 patches have errors.
>
> Could you send me your result?
> I ran checkpatch.pl again on these patches but didn't see any error.

I get a whole bunch of:
ERROR: DOS line endings

I suppose it's because of the configuration of your mail client.

Best regards,
Matthias

>
> Joe.C
>
>



-- 
motzblog.wordpress.com
