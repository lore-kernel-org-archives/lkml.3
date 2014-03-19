Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbaCSRPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:15:09 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:62161 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013AbaCSRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:15:00 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-14.tower-178.messagelabs.com!1395249297!26008670!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V2] mfd: da9063: Add support for production silicon
 variant code
Thread-Topic: [RFC V2] mfd: da9063: Add support for production silicon
 variant code
Thread-Index: AQHPKaPjGoIDakt27U6TyM0JXmSxpZrg0n+AgARPolCAA7XqcA==
Date: Wed, 19 Mar 2014 17:14:54 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A18F5A46@SW-EX-MBX02.diasemi.com>
References: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
	 <20140214164319.GB30687@lee--X1>
 <1394807833.3710.57.camel@paszta.hi.pengutronix.de> 
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.50.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2JHFJGi014844

On 17 March 2014 08:34, Steve Twiss wrote:

>On 14 March 2014 14:37 Philipp Zabel wrote:
>>Am Freitag, den 14.02.2014, 16:43 +0000 schrieb Lee Jones:
>>> > From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>> >
>>> > Add the correct silicon variant code ID (0x5) to the driver. This
>>> > new code is the 'production' variant code ID for DA9063.
>>> >
>>> > This patch will remove the older variant code ID which matches the
>>> > pre-production silicon ID (0x3) for the DA9063 chip.
>>> >
>>> > There is also some small amount of correction done in this patch:
>>> > it splits the revision code and correctly names it according to
>>> > the hardware specification and moves the dev_info() call before
>>> > the variant ID test.
>>> >
>>> > Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>>
>>> Applied, thanks.
>>
>>we have a few i.MX6 Modules (imx6q-phytec-pfla02) with DA9063 PMICs that
>>all report the model/revision ID as 0x61/0x03. Those are marked as
>>follows:
>>    dialog DA9063 44 1240EHDA
>>    dialog DA9063 44 1312ECAF
>>We now have received a report from Phytec that those PMICs were not
>>marketed as preproduction in any way, but as a normal mask revision.
>>Their Dialog Semiconductor contact talked about AD, BA, and BB silicon
>>variants. How do those relate to the variant register value and to the
>>markings on the chips?
>>There seems to be a serious miscommunication somewhere.
>
>I will speak with our AEs this morning and try and get an answer to this one.

Hi Philipp,

Phytec informs us that you already asked them for this and have confirmed
that you should have all necessary information now

Best regards,
Steve

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
