Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaCZILN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:11:13 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.176]:61411 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbaCZILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:11:08 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-39.messagelabs.com!1395821463!9983437!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: RE: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPPSVKUI+aJH4Lh0O1h4CC/fc/HJrzFnoLgAAEtcA=
Date: Wed, 26 Mar 2014 08:11:02 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A2AFE6A6@SW-EX-MBX01.diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
 <93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
 <20140311122725.GK21216@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB7A2AFD1F8@SW-EX-MBX01.diasemi.com>
 <20140326075243.GE24823@lee--X1>
In-Reply-To: <20140326075243.GE24823@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q8BN6M027894

>> I realise that you and Alessandro are very busy (I have not often seen
>> Alessandro do any posting in the past fortnight), but a  couple of weeks
>> ago I sent an RTC patch set with register.h changes ...
>>
>> >> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> >>
>> >> Add the RTC driver for DA9063.
>> <snip>
>> >> The original patch is here:
>> >>  - https://lkml.org/lkml/2014/3/6/346
>>
>> I believe you applied the first half of my alterations here:
>> https://lkml.org/lkml/2014/3/6/348
>> https://lkml.org/lkml/2014/3/10/369
>>
>> And the other half, was Acked by Alessandro Zummo here:
>> https://lkml.org/lkml/2014/3/7/112
>>
>> On 11 March 2014 12:27, Lee Jones wrote:
>> >
>> >Alessandro,
>> >  Are you happy for me to take this set through the MFD tree and send
>> >  you a pull-request for an immutable branch?
>> >
>>
>> There was a suggestion that this RTC patch could be taken through by you?
>> Can I ask if this still an option please?
>>
>> I tried to contact Alessandro after about 1 week, but I guess that other things
>> are getting in the way and I have not had a reply.
>> https://lkml.org/lkml/2014/3/21/248
>>
>> The reason I ask -- is because I have several patches waiting to add support
>> for an older variant of the silicon, but in order to send those changes I will
>> need to patch the pending RTC with the updates.
>
>I can't really take the RTC patches without Alessandro's consent.
>Besides, the merge window is going to open in about a week. I'm sorry
>to say this, but I think this set is best left for v3.16 now. That
>also gives Alessandro a while to reply properly.
>

Okay, thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
