Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbaCUOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:18:20 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:36611 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbaCUOSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:18:15 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-3.tower-39.messagelabs.com!1395411488!12344005!2
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: RE: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPPSVKUI+aJH4Lh0O1h4CC/fc/HJrro5vQ
Date: Fri, 21 Mar 2014 14:17:45 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A2AF6729@SW-EX-MBX01.diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
 <93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
 <20140311122725.GK21216@lee--X1>
In-Reply-To: <20140311122725.GK21216@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2LEIOMZ000471

Hi Alessandro,

Just over a week ago I sent a patch for the rtc: da9063: RTC driver file that
added RTC support for the DA9063 currently in the kernel.

I'm not sure if it may have been missed in your inbox
https://lkml.org/lkml/2014/3/11/230

The RTC patch was previously Acked by you here:
https://lkml.org/lkml/2014/3/7/112


On 11 March 2014 12:27, Lee Jones wrote:

>Subject: Re: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> Add the RTC driver for DA9063.
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> Acked-by: Alessandro Zummo <a.zummo@towertech.it>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>
>How could I have Acked a patch that I've never seen?
>
><snip>
>
>> The original patch is here:
>>  - https://lkml.org/lkml/2014/3/6/346
>>
>> This patch resend is identical to the original patch, except it adds
>> the Acked-by: line from Alessandro Zummo, previously provided here:
>>  - https://lkml.org/lkml/2014/3/7/112
>>
>> Also, it adds an Acked-by line on behalf of Lee Jones, as requested:
>>  - https://lkml.org/lkml/2014/3/10/369
>
>Ah, no. I meant send the set with my Ack applied to the patch I
>actually reviewed.
>
>Alessandro,
>  Are you happy for me to take this set through the MFD tree and send
>  you a pull-request for an immutable branch?
>

I believe that I made a mess of the resend and Ack'ed when I shouldn't
have on Lee Jones's behalf -- but then there was a reply from Lee who
suggested that he could take the patch through despite this.
I think that was his intention.
(Lee: I hope I am not stepping outside the line again!)

If you have time to quickly take another look at this, then I would
appreciate that.

Thank you,
Steve
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
