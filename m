Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3IPJ5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:57:42 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:58084 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab3IPJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:57:41 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Mon, 16 Sep 2013 11:57:04 +0200
Subject: Re: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct
 group
Thread-Topic: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct
 group
Thread-Index: Ac6ywxq7PbO/1xtrSOOA2QzUkJt2jw==
Message-ID: <5236D5F0.2030601@st.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
 <5234A20F.7040008@kernel.org> <20130916080546.GC3999@lee--X1>
 <5236CD17.5010901@st.com> <20130916093812.GG3999@lee--X1>
In-Reply-To: <20130916093812.GG3999@lee--X1>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8G9vvZ1003176

Hi Lee,

> That's what the datasheet for the board says. Perhaps it's that that's 
> incorrect? Annoyingly, instead of printing the device name on the 
> package, ST put some non-Googleable nonsense is there instead 
> (probably the serial number). Nevertheless, I'll revert the patch and 
> work something else out.

I've tried with real device...Unfortunately, you are right for name on 
the package...
So, are you using the LSM303DLHC?

Denisÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
